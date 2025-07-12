#!/bin/bash

# KyOS Technical Whitepaper Compilation Script
# This script compiles the LaTeX whitepaper document

set -e

DOCNAME="KyOS-Technical-Whitepaper"
TEXFILE="${DOCNAME}.tex"
PDFFILE="${DOCNAME}.pdf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if LaTeX is installed
check_latex() {
    print_status "Checking LaTeX installation..."
    
    if ! command -v pdflatex &> /dev/null; then
        print_error "pdflatex is not installed!"
        print_status "Please install LaTeX:"
        echo "  Arch Linux: sudo pacman -S texlive-core texlive-latexextra"
        echo "  Ubuntu: sudo apt-get install texlive-latex-base texlive-latex-extra"
        echo "  Fedora: sudo dnf install texlive-latex texlive-collection-latexextra"
        exit 1
    fi
    
    print_success "LaTeX installation found"
}

# Compile the document
compile_document() {
    print_status "Compiling ${TEXFILE}..."
    
    # First pass
    print_status "Running first compilation pass..."
    pdflatex -interaction=nonstopmode "${TEXFILE}" > compile.log 2>&1
    
    # Check if PDF was generated (better indicator than exit code)
    if [[ -f "${PDFFILE}" ]]; then
        print_success "First pass completed"
    else
        print_error "First pass failed! PDF not generated. Check compile.log for errors."
        print_status "Last few lines of compile.log:"
        tail -10 compile.log
        return 1
    fi
    
    # Second pass for references
    print_status "Running second compilation pass for references..."
    pdflatex -interaction=nonstopmode "${TEXFILE}" > compile.log 2>&1
    
    if [[ -f "${PDFFILE}" ]]; then
        print_success "Second pass completed"
    else
        print_warning "Second pass had issues, but checking if PDF exists..."
    fi
    
    if [[ -f "${PDFFILE}" ]]; then
        print_success "PDF generated successfully: ${PDFFILE}"
        
        # Get file size
        FILE_SIZE=$(du -h "${PDFFILE}" | cut -f1)
        print_status "PDF size: ${FILE_SIZE}"
        
        # Get page count
        if command -v pdfinfo &> /dev/null; then
            PAGE_COUNT=$(pdfinfo "${PDFFILE}" 2>/dev/null | grep "Pages:" | awk '{print $2}')
            if [[ -n "$PAGE_COUNT" ]]; then
                print_status "Page count: ${PAGE_COUNT} pages"
            fi
        fi
        
        return 0
    else
        print_error "PDF was not generated!"
        return 1
    fi
}

# Clean auxiliary files
clean_files() {
    print_status "Cleaning auxiliary files..."
    rm -f *.aux *.log *.toc *.out *.nav *.snm *.vrb *.bbl *.blg *.fls *.fdb_latexmk *.synctex.gz
    print_success "Cleanup completed"
}

# View PDF
view_pdf() {
    if [[ -f "${PDFFILE}" ]]; then
        print_status "Opening PDF viewer..."
        
        # Try different PDF viewers
        if command -v evince &> /dev/null; then
            evince "${PDFFILE}" &
        elif command -v okular &> /dev/null; then
            okular "${PDFFILE}" &
        elif command -v zathura &> /dev/null; then
            zathura "${PDFFILE}" &
        elif command -v xdg-open &> /dev/null; then
            xdg-open "${PDFFILE}" &
        else
            print_warning "No PDF viewer found. Please open ${PDFFILE} manually."
        fi
    else
        print_error "PDF file not found. Compile first with: $0 compile"
    fi
}

# Show help
show_help() {
    echo "KyOS Technical Whitepaper Compilation Script"
    echo "============================================"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  compile    - Compile the LaTeX document to PDF (default)"
    echo "  clean      - Remove auxiliary files"
    echo "  view       - Open the PDF in a viewer"
    echo "  check      - Check LaTeX installation"
    echo "  all        - Compile and view the document"
    echo "  help       - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0           # Compile the document"
    echo "  $0 compile   # Compile the document"
    echo "  $0 view      # Open PDF viewer"
    echo "  $0 all       # Compile and view"
    echo "  $0 clean     # Clean auxiliary files"
}

# Main script logic
main() {
    case "${1:-compile}" in
        "compile")
            check_latex
            compile_document
            ;;
        "clean")
            clean_files
            ;;
        "view")
            view_pdf
            ;;
        "check")
            check_latex
            ;;
        "all")
            check_latex
            compile_document && view_pdf
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
