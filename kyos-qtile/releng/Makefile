# Makefile for KyOS Technical Whitepaper

# Variables
DOCNAME = KyOS-Technical-Whitepaper
TEXFILE = $(DOCNAME).tex
PDFFILE = $(DOCNAME).pdf
LATEX = pdflatex
BIBTEX = bibtex
VIEWER = evince

# Default target
all: $(PDFFILE)

# Build PDF
$(PDFFILE): $(TEXFILE)
	@echo "Compiling LaTeX document..."
	$(LATEX) $(TEXFILE)
	@echo "Running second pass for references..."
	$(LATEX) $(TEXFILE)
	@echo "PDF compilation completed: $(PDFFILE)"

# Clean auxiliary files
clean:
	@echo "Cleaning auxiliary files..."
	rm -f *.aux *.log *.toc *.out *.nav *.snm *.vrb *.bbl *.blg *.fls *.fdb_latexmk *.synctex.gz
	@echo "Cleanup completed."

# Clean everything including PDF
distclean: clean
	@echo "Removing PDF output..."
	rm -f $(PDFFILE)
	@echo "Full cleanup completed."

# View PDF
view: $(PDFFILE)
	@echo "Opening PDF viewer..."
	$(VIEWER) $(PDFFILE) &

# Install to system documentation (requires sudo)
install: $(PDFFILE)
	@echo "Installing to system documentation..."
	sudo mkdir -p /usr/share/doc/kyos/
	sudo cp $(PDFFILE) /usr/share/doc/kyos/
	sudo chmod 644 /usr/share/doc/kyos/$(PDFFILE)
	@echo "Installation completed to /usr/share/doc/kyos/"

# Force rebuild
rebuild: clean all

# Check LaTeX installation
check:
	@echo "Checking LaTeX installation..."
	@which $(LATEX) > /dev/null && echo "✓ pdflatex found" || echo "✗ pdflatex not found"
	@which $(BIBTEX) > /dev/null && echo "✓ bibtex found" || echo "✗ bibtex not found"
	@echo "Required packages check:"
	@kpsewhich article.cls > /dev/null && echo "✓ article.cls found" || echo "✗ article.cls not found"
	@kpsewhich geometry.sty > /dev/null && echo "✓ geometry.sty found" || echo "✗ geometry.sty not found"
	@kpsewhich xcolor.sty > /dev/null && echo "✓ xcolor.sty found" || echo "✗ xcolor.sty not found"
	@kpsewhich listings.sty > /dev/null && echo "✓ listings.sty found" || echo "✗ listings.sty not found"
	@kpsewhich hyperref.sty > /dev/null && echo "✓ hyperref.sty found" || echo "✗ hyperref.sty not found"

# Help
help:
	@echo "KyOS Technical Whitepaper - Makefile Help"
	@echo "========================================"
	@echo "Available targets:"
	@echo "  all        - Compile the PDF (default)"
	@echo "  clean      - Remove auxiliary files"
	@echo "  distclean  - Remove all generated files"
	@echo "  view       - Open PDF in viewer"
	@echo "  install    - Install to system documentation"
	@echo "  rebuild    - Clean and rebuild"
	@echo "  check      - Check LaTeX installation"
	@echo "  help       - Show this help message"
	@echo ""
	@echo "Usage examples:"
	@echo "  make           # Compile PDF"
	@echo "  make clean     # Clean auxiliary files"
	@echo "  make view      # Compile and view PDF"
	@echo "  make install   # Install to system"

# Phony targets
.PHONY: all clean distclean view install rebuild check help

# Default shell
SHELL = /bin/bash
