#
# dev-init - Development Environment Initializer
#
# A convenience wrapper around `nix flake init` that simplifies
# creating project-specific development environments.
#
{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "dev-init" ''
      #!/usr/bin/env bash
      set -euo pipefail

      REPO="github:SrwR16/nixos-configs"
      
      # ANSI color codes
      RED='\033[0;31m'
      GREEN='\033[0;32m'
      YELLOW='\033[1;33m'
      BLUE='\033[0;34m'
      PURPLE='\033[0;35m'
      CYAN='\033[0;36m'
      NC='\033[0m' # No Color

      show_help() {
        echo -e "''${CYAN}╔══════════════════════════════════════════════════════════════╗''${NC}"
        echo -e "''${CYAN}║     🚀 Development Environment Initializer (dev-init)       ║''${NC}"
        echo -e "''${CYAN}╚══════════════════════════════════════════════════════════════╝''${NC}"
        echo ""
        echo -e "''${YELLOW}Usage:''${NC} dev-init <template>"
        echo ""
        echo -e "''${PURPLE}📦 Available Templates:''${NC}"
        echo ""
        echo -e "  ''${GREEN}Programming Languages:''${NC}"
        echo -e "    python              Python development"
        echo -e "    node                Node.js/TypeScript"
        echo -e "    go                  Golang development"
        echo -e "    rust                Rust development"
        echo -e "    c                   C/C++ development"
        echo -e "    java                Java development"
        echo -e "    php                 PHP development"
        echo ""
        echo -e "  ''${GREEN}Machine Learning & AI:''${NC}"
        echo -e "    torch-basics        PyTorch ML environment"
        echo -e "    langchain-basics    LLM/AI applications"
        echo -e "    pybind11-starter-kit Python + C++ bindings"
        echo -e "    maturin-basics      Rust + Python (PyO3)"
        echo -e "    cpp-starter-kit     C++ with CMake & testing"
        echo -e "    js-webapp-basics    JavaScript/TypeScript web"
        echo ""
        echo -e "  ''${GREEN}DevOps & Infrastructure:''${NC}"
        echo -e "    devops              Full DevOps stack (RECOMMENDED)"
        echo -e "    kubernetes          K8s development tools"
        echo -e "    terraform           Terraform/IaC environment"
        echo -e "    cicd                CI/CD pipeline tools"
        echo -e "    cloud               Multi-cloud CLI tools"
        echo ""
        echo -e "''${YELLOW}Examples:''${NC}"
        echo -e "  dev-init devops              # Initialize DevOps environment"
        echo -e "  dev-init kubernetes          # Initialize K8s environment"
        echo -e "  dev-init python              # Initialize Python environment"
        echo ""
        echo -e "''${BLUE}What happens:''${NC}"
        echo -e "  1. Copies flake.nix from template"
        echo -e "  2. Creates .envrc for direnv"
        echo -e "  3. Allows direnv automatically"
        echo -e "  4. Environment loads immediately"
        echo ""
      }

      # Show help if no arguments
      if [ $# -eq 0 ]; then
        show_help
        exit 0
      fi

      TEMPLATE="$1"

      # Check if already initialized
      if [ -f "flake.nix" ]; then
        echo -e "''${YELLOW}⚠️  Warning: flake.nix already exists in current directory''${NC}"
        echo -n "Overwrite? (y/N): "
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
          echo -e "''${RED}Cancelled''${NC}"
          exit 0
        fi
      fi

      echo -e "''${CYAN}╔══════════════════════════════════════════════════════════════╗''${NC}"
      echo -e "''${CYAN}║          Initializing Development Environment               ║''${NC}"
      echo -e "''${CYAN}╚══════════════════════════════════════════════════════════════╝''${NC}"
      echo ""

      # Initialize from template
      echo -e "''${BLUE}📋 Copying template '$TEMPLATE'...''${NC}"
      if ! nix flake init -t "$REPO#$TEMPLATE" 2>&1; then
        echo -e "''${RED}❌ Error: Template '$TEMPLATE' not found''${NC}"
        echo ""
        echo -e "''${YELLOW}Run 'dev-init' without arguments to see available templates.''${NC}"
        exit 1
      fi

      # Create .envrc for direnv
      echo -e "''${BLUE}📝 Creating .envrc...''${NC}"
      echo "use flake" > .envrc

      # Allow direnv
      echo -e "''${BLUE}🔄 Allowing direnv...''${NC}"
      direnv allow

      echo ""
      echo -e "''${GREEN}✅ Development environment initialized successfully!''${NC}"
      echo ""
      echo -e "''${PURPLE}Created files:''${NC}"
      echo -e "  📄 flake.nix  (development environment)"
      echo -e "  📄 .envrc     (direnv configuration)"
      echo ""
      echo -e "''${YELLOW}💡 Next steps:''${NC}"
      echo -e "  • The environment will load automatically via direnv"
      echo -e "  • Run 'nix develop' to manually enter the environment"
      echo -e "  • Edit flake.nix to customize packages"
      echo -e "  • Run 'direnv reload' after modifying flake.nix"
      echo ""
    '')
  ];
}
