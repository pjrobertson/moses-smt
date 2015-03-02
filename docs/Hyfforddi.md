# Creu Peiriannau Moses-SMT
Mae modd hyfforddi eich system Moses-SMT gyda data sy'n perthyn i'r Uned Technolegau Iaith
neu gyda'ch eich data eich hunain. 

## Pam hyfforddi peiriannau gan ddefnyddio eich data eich hunain?

Gall hyfforddi eich peiriant eich hunain gynnig y cyfle i siapio peiriant cyfieithu sy'n adlewyrchu eich anghenion arbennigol
chi o fewn pau bennodol. Er enghraifft, os ydych yn gweithio ym maes cyllid, byddai'n bosib hyfforddi y peiriant i fod yn arbennig
o effeithiol wrth gyfieithu cywair yn y maes hwn, gan gynnwys termau a chastrawen arbennigol y maes. 

## Hyfforddi gyda data corpora Uned Technolegau Iaith
Os hoffwch chi hyfforddi gan ddefnyddio data yr Uned Technolegau Iaith, sy'n dod o ffynonellau megis 
Cofnod y Cynulliad a'r corpws Ddeddfwriaeth, yna mae na dri orchymun syml i'w defnyddio. 

Yn gyntaf mae angen estyn y data rydym yn bwriadu ei ddefnyddio:

``` sh
moses@ubuntu:~/moses-smt$ python moses.py fetchcorpus -e CofnodYCynulliad
```
Pwrpas yr ail orchymyn yw i hyfforddi a dynodi'r cyfeiriad cyfieithu (e.e. o Gymraeg i Saesneg, neu o Saesneg i'r Gymraeg). 
Byddwch angen cyfrifiadur gyda dros 4Gb o gof. Bydd y broses yn cymryd rhai oriau i gwblhau.

I hyfforddi peiriant cyfieithu gan ddefnyddio data CofnodYCynulliad i gyfieithu o Saesneg i'r Gymraeg:

``` sh
moses@ubuntu:~/moses-smt$ python moses.py train -e CofnodYCynulliad -s en -t cy
```

Ac yna i'w gychwyn:

``` sh
moses@ubuntu:~/moses-smt$ python moses.py start -e CofnodYCynulliad -s en -t cy
```

[Gweler y dudalen canlynol](RhedegMoses.md) am rhagor ar sut gellir rhedeg Moses-SMT


## Hyfforddi gyda data corpora eich hunain

Rhaid gosod eich testun fel ffeiliau testun cyfochrog o fewn is-ffolder sydd 
wedi ei henwi ar ôl enw eich peiriant newydd;

e.e. os yw'r data yn dod o hen gyfieithiadau 'Marchnata' yna defnyddiwch y gorchymyn canlynol :

```sh
moses@ubuntu:~/moses-smt$ mkdir -p ~/moses-models/Marchnata/corpus
```

Rhowch y ffeil Cymraeg o fewn ffeil gyda enw'r corpws a'r estyniad '.cy'. 

Rhowch y data Saesneg o fewn ffeil sydd â'r enw'r corpws a'r estyniad '.en'. 

```sh
moses@ubuntu:~/moses-smt$ cd ~/moses-models/Marchnata/corpus
moses@ubuntu:~/moses-models/Marchnata/corpus$ ls
Marchnata.cy  Marchnata.en
```

Mae'r broses hyfforddi yn debyg i'r camau ochod, sef :

``` sh
moses@ubuntu:~/moses-smt$ python moses.py train -e Marchnata -s en -t cy
```

Ac yna i'w gychwyn:

``` sh
moses@ubuntu:~/moses-smt$ python moses.py start -e Marchnata -s en -t cy
```

# Create Moses-SMT machines
It's possible to train Moses-SMT to machine translate with data belonging to the Language Technologies Unit or your own data.

## Why train translation machines with your own data?

Training your own translation machine could be an opportunity to create a machine 
that can reflect your specific needs within the field in which you work. For example, 
if you worked in finance, it would be possible to train your machine to be particularly effective
at translating the register of this domain, including the field's own particular terminology and syntax.

## Training with the Language Technology Unit's Data
I you want to train with th Language Technologies Unit's data, which comes from sources like the
Proceedings of the National Assembly and the Legislation corpus, then you will need to use three simple commands. 

First, you need to fetch the data that we will be using: 

``` sh
moses@ubuntu:~/moses-smt$ python moses.py fetchcorpus -e CofnodYCynulliad
```
The second command is to train and state the direction that the translation will take (i.e. Welsh to English or English to Welsh). 
You will need a computer that has at least more than 4GB of memory. The entire process will take a few hours to complete. 

In order to train a translation machine using the CofnodYCynulliad (the Proceedings of the National Assembly corpus) data that can translate from English to Welsh, you will need:

``` sh
moses@ubuntu:~/moses-smt$ python moses.py train -e CofnodYCynulliad -s en -t cy
```

And then to start it:

``` sh
moses@ubuntu:~/moses-smt$ python moses.py start -e CofnodYCynulliad -s en -t cy
```

[See the following page](RhedegMoses.md) for more on how to run Moses-SMT

## Training with your own corpus data
 You will need to set out your text as paralell files in a sub-folder
which is named after your new machine; 


For example, if you have data from old translations of 'Marketing', then create :

```sh
moses@ubuntu:~/moses-smt$ mkdir -p ~/moses-models/Marchnata/corpus
```

Place the Welsh file in a file with the corpus' name, and the extension'.cy'. Then, place the English data in a file which also has the corpus' name, but with the extension '.en'. 

```sh
moses@ubuntu:~/moses-smt$ cd ~/moses-models/Marchnata/corpus
moses@ubuntu:~/moses-models/Marchnata/corpus$ ls
Marchnata.cy  Marchnata.en
```

To train your own machine :

``` sh
moses@ubuntu:~/moses-smt$ python moses.py train -e Marchnata -s en -t cy
```

To start it :

``` sh
moses@ubuntu:~/moses-smt$ python moses.py start -e Marchnata -s en -t cy
```