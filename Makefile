# ===========================
# Makefile for data pipeline
# ===========================

# Novels to process
TEXTS := isles abyss last sierra

DATA_DIR := data
RESULTS_DIR := results
FIG_DIR := $(RESULTS_DIR)/figure

DOCS_DIR := docs
DOCS_FIG_DIR := $(DOCS_DIR)/figure

REPORT_QMD := report/count_report.qmd
REPORT_HTML := report/count_report.html
DOCS_REPORT := $(DOCS_DIR)/index.html

# Auto-generated files
DAT_FILES := $(TEXTS:%=$(RESULTS_DIR)/%.dat)
PNG_FILES := $(TEXTS:%=$(FIG_DIR)/%.png)
DOCS_PNG_FILES := $(TEXTS:%=$(DOCS_FIG_DIR)/%.png)

.PHONY: all clean

# ---------------------------
# Main pipeline
# ---------------------------

# Run the whole analysis and prepare GitHub Pages files
all: $(DOCS_REPORT) $(DOCS_PNG_FILES)

# ---------------------------
# Data: .txt -> .dat
# ---------------------------

$(RESULTS_DIR)/%.dat: $(DATA_DIR)/%.txt | $(RESULTS_DIR)
	python scripts/wordcount.py --input_file=$< --output_file=$@

$(RESULTS_DIR):
	mkdir -p $@

# ---------------------------
# Figures: .dat -> .png
# ---------------------------

$(FIG_DIR)/%.png: $(RESULTS_DIR)/%.dat | $(FIG_DIR)
	python scripts/plotcount.py --input_file=$< --output_file=$@

$(FIG_DIR):
	mkdir -p $@

# ---------------------------
# Report: .qmd -> .html
# ---------------------------

# This assumes Quarto writes report/count_report.html
$(REPORT_HTML): $(REPORT_QMD) $(PNG_FILES)
	quarto render $<

# ---------------------------
# GitHub Pages: docs/
# ---------------------------

$(DOCS_DIR):
	mkdir -p $@

$(DOCS_FIG_DIR):
	mkdir -p $@

# Copy figures into docs/figure/
$(DOCS_FIG_DIR)/%.png: $(FIG_DIR)/%.png | $(DOCS_FIG_DIR)
	cp $< $@

# Create docs/index.html with fixed image paths
$(DOCS_REPORT): $(REPORT_HTML) | $(DOCS_DIR)
	# Rewrite image paths so they work from docs/ on GitHub Pages
	sed -e 's|\.\./results/figure/|figure/|g' \
	    -e 's|results/figure/|figure/|g' $< > $@

# ---------------------------
# Clean up generated files
# ---------------------------

clean:
	# Remove intermediate data and figures
	rm -f $(DAT_FILES)
	rm -f $(PNG_FILES)

	# Remove rendered report
	rm -f $(REPORT_HTML)

	# Remove GitHub Pages outputs
	rm -f $(DOCS_REPORT)
	rm -f $(DOCS_PNG_FILES)
	-rmdir $(DOCS_FIG_DIR) 2>/dev/null || true
