#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from argparse import ArgumentParser

DEFAULT_TRAINING_DATA_URL = "http://techiaith.org/corpws/Moses"
DEFAULT_ENGINES_URL = "http://techiaith.org/moses"

MOSES_HOME = "/home/moses"
MOSESMODELS_HOME = os.path.join(MOSES_HOME, "moses-models")
MTDK_HOME = os.path.join(os.path.dirname(__file__), "mtdk")

DESCRIPTION = """Sgript Hyfforddi a chychwyn rhedeg system cyfieithu peirianyddol Moses
© Prifysgol Bangor University
"""

class MosesRunError(Exception):
	pass

def run_commands(cmds):
	for cmd in cmds:
		cmd = u" ".join(cmd)
		print("Rhedeg %s" % cmd)
		returncode = os.system(cmd)
		if returncode != 0:
			exception_str = ["Problem yn rehedeg y gorchymyn:", "      %s" % cmd]
			raise MosesRunError(u"\n".join(exception_str))

def script_path(script):
	path = os.path.join(MTDK_HOME, script)
	if not os.path.exists(path):
		raise MosesRunError("Nid yw'r path '%s' yn bodoli.\nYdych chi wedi gosod y ffeiliau i gyd yn iawn?" % path)
	return path

def fetchcorpus(engine_name, **args):
	"""Lawrlwytho data corpws / Download corpus data"""

	data_url = os.path.join(DEFAULT_TRAINING_DATA_URL, engine_name, "%s.tar.gz" % engine_name)
	
	prepare_engine_cmd = [script_path("mtdk-00-prepare-new-engine.sh"), "-h", MOSESMODELS_HOME, "-e", engine_name, "-u", data_url]
	prepare_corpus_cmd = [script_path("mtdk-01-prepare-corpus.sh"), "-m", MOSES_HOME, "-h", MOSESMODELS_HOME, "-e", engine_name]
	
	run_commands([prepare_engine_cmd, prepare_corpus_cmd])

def fetchengine(engine_name, source_lang, target_lang, **args):
	"""Lawrlwytho peiriant cyfieithu o techiaith.org / Download a translation engine from techiaith.org"""

	download_engine_cmd = [script_path("mt_download_engine.sh"),"-m", MOSES_HOME, "-h", MOSESMODELS_HOME, "-e", engine_name, "-s", source_lang, "-t", target_lang] 

	run_commands([download_engine_cmd])

def train(engine_name, source_lang, target_lang, **args):
	"""Hyfforddi model iaith Moses / Train Moses' language model"""
	
	script_params = ["-m", MOSES_HOME, "-h", MOSESMODELS_HOME, "-e", engine_name]
	train_lang_model_cmd = [script_path("mtdk-02-train-language-model.sh")] + script_params + ["-t", target_lang]
	
	train_translation_cmd = [script_path("mtdk-03-train-translation-engine.sh")] + script_params + ["-s", source_lang, "-t", target_lang]
	
	compress_translation_cmd = [script_path("mtdk-04-compress-translation-engine-ram.sh")] + script_params + ["-s", source_lang, "-t", target_lang]
	
	run_commands([train_lang_model_cmd, train_translation_cmd, compress_translation_cmd])

def start(engine_name, source_lang, target_lang, **args):
	"""Cychwyn y gweinydd Moses / Start the Moses Server"""
	
	source_target_lang = "%s-%s" % (source_lang, target_lang)
	cmd = [os.path.join(MOSES_HOME, "mosesdecoder", "bin", "mosesserver"), "-f", os.path.join(MOSESMODELS_HOME, engine_name, source_target_lang, "engine", "model", "moses.ini")]
	run_commands([cmd])

if __name__ == "__main__":
	
	parser = ArgumentParser(description=DESCRIPTION)
	subparsers = parser.add_subparsers(title="Is-gorchmynion", description="Is-gorchmynion dilys", help="a ddylid llwytho, hyfforddi ynte cychwyn y peiriant")
	fetchparser = subparsers.add_parser('fetchcorpus')
	fetchparser.add_argument('-e', '--engine', dest="engine_name", required=True, help="enw i'r peiriant cyfieithu benodol")
	fetchparser.set_defaults(func=fetchcorpus)

	fetchengineparser = subparsers.add_parser('fetchengine')
	fetchengineparser.add_argument('-e','--engine', dest="engine_name", required=True, help="enw i'r peiriant cyfieithu benodol")
	fetchengineparser.add_argument('-s', '--sourcelang', dest="source_lang", required=True, help="iaith ffynhonnell")
        fetchengineparser.add_argument('-t', '--targetlang', dest="target_lang", required=True, help="iaith targed")
	fetchengineparser.set_defaults(func=fetchengine)
	
	trainparser = subparsers.add_parser('train')
	trainparser.add_argument('-e', '--engine', dest="engine_name", required=True, help="enw i'r peiriant cyfieithu benodol")
	trainparser.add_argument('-s', '--sourcelang', dest="source_lang", required=True, help="iaith ffynhonnell")
	trainparser.add_argument('-t', '--targetlang', dest="target_lang", required=True, help="iaith targed")
	trainparser.set_defaults(func=train)
	
	startparser = subparsers.add_parser('start')
	startparser.add_argument('-e', '--engine', dest="engine_name", required=True, help="enw i'r peiriant cyfieithu benodol")
	startparser.add_argument('-s', '--sourcelang', dest="source_lang", required=True, help="iaith ffynhonnell")
	startparser.add_argument('-t', '--targetlang', dest="target_lang", required=True, help="iaith targed")
	startparser.set_defaults(func=start)
	
	args = parser.parse_args()
	try:
		args.func(**vars(args))
	except MosesRunError as e:
		print("\n**ERROR**\n")
		print(e)
