data_dir = data
models_dir = models

conllu_train = $(data_dir)/train.conllu
conllu_dev = $(data_dir)/dev.conllu
conllu_test = $(data_dir)/test.conllu

spacy_train = $(data_dir)/train.spacy
spacy_dev = $(data_dir)/dev.spacy
spacy_test = $(data_dir)/test.spacy

# truncated files
#conllu_train_head = $(data_dir)/train_head.conllu
#conllu_dev_head = $(data_dir)/dev_head.conllu

base_config = base_config.cfg
full_config = config.cfg

model_best = $(models_dir)/model-best

.PHONY: readme download train eval show

readme:
	@echo "I used SpaCy to train a POS tagger for the Urdu language.I get the training data from Urdu Treebank of Universal Dependencies. Since Urdu is not supported in its SpaCy's core models, I used SpaCy's multilingual model (xx_ent_wiki_sm) which is designed to work with multiple langauges. I choosed Urdu to to check how well it performs on a model trained in multiple different languages. The accuracy achieved is around 89.96% which can be improved by either using models which are trained on languages that are very closly related to Urdu or by using custom models created for Urdu. The accuracy can reduce further by using such model for complex tasks in Urdu."


download:
	mkdir -p $(data_dir)
	wget -O $(conllu_train) https://raw.githubusercontent.com/UniversalDependencies/UD_Urdu-UDTB/refs/heads/master/ur_udtb-ud-train.conllu
	wget -O $(conllu_dev) https://raw.githubusercontent.com/UniversalDependencies/UD_Urdu-UDTB/refs/heads/master/ur_udtb-ud-dev.conllu
	wget -O $(conllu_test) https://raw.githubusercontent.com/UniversalDependencies/UD_Urdu-UDTB/refs/heads/master/ur_udtb-ud-test.conllu

download_model:
	python3 -m spacy download xx_ent_wiki_sm


#truncate_train_dev_set:
#	head -n 20037 $(conllu_train) > $(conllu_train_head)
#	head -n 2526 $(conllu_dev) > $(conllu_dev_head)

#convert: truncate_train_dev_set
#	python3 -m spacy convert $(conllu_train_head) $(data_dir) --n-sents 10
#	python3 -m spacy convert $(conllu_dev_head) $(data_dir) --n-sents 10
#	python3 -m spacy convert $(conllu_test) $(data_dir) --n-sents 10


convert: 
	python3 -m spacy convert $(conllu_train) $(data_dir) --n-sents 10
	python3 -m spacy convert $(conllu_dev) $(data_dir) --n-sents 10
	python3 -m spacy convert $(conllu_test) $(data_dir) --n-sents 10
	
	

create_full_config: $(base_config)
	python3 -m spacy init fill-config $(base_config) $(full_config)
	

train:
	mkdir -p $(models_dir)
	python3 -m spacy train $(full_config) \
		--output $(models_dir) \
		--paths.train $(spacy_train) \
		--paths.dev $(spacy_dev)
	mv $(models_dir)/*/model-best $(models_dir)/model-best
		

eval: $(model_best) $(spacy_test)
	python3 -m spacy evaluate $(model_best) $(spacy_test)


show:
	python3 show_model.py
