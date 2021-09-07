# Simple makefile to compile the guideline
SRC_DIR = src
BUILD_DIR = pdf
TMP_DIR = tmp

IMG_DIR = $(SRC_DIR)/img
MD_DIR = $(SRC_DIR)/md
TEX_DIR = $(SRC_DIR)/tex

MD_MAIN_FILES = $(shell find $(MD_DIR)/main -type f | sort )
MD_APP_FILES = $(shell find $(MD_DIR)/app -type f | sort )

TEX_APP_FILE = $(TMP_DIR)/appendix.tex

TEMPLATE = $(TEX_DIR)/template.tex
UU_REPORT = $(shell find $(SRC_DIR) -name "uureport" -type d)

export TEXINPUTS:=$(UU_REPORT):

PDF_FILE = $(BUILD_DIR)/guideline.pdf

.PHONY : all
all : guideline

$(BUILD_DIR) :
	@mkdir -p $@

.PHONY : guideline

guideline : $(PDF_FILE)

$(PDF_FILE) : $(MD_FILES) $(TEX_APP_FILE) | $(BUILD_DIR)
	@echo "> Compiling guideline ..." && pandoc -s -f markdown -t pdf --template=$(TEMPLATE) --top-level-division=chapter $(MD_MAIN_FILES) -o $@ && echo "> Done!"

$(TEX_APP_FILE) : $(MD_APP_FILES) | $(TMP_DIR)
	@pandoc -f markdown -t latex $(MD_APP_FILES) --top-level-division=chapter -o $(TEX_APP_FILE)

$(TMP_DIR) :
	@mkdir -p $@

.PHONY : clean
clean :
	@rm -rf $(BUILD_DIR) $(TMP_DIR)
