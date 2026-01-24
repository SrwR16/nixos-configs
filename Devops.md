# DevOps Enhancement Guide for bydmiller/nixos-configs

This guide provides a complete implementation plan to enhance `bydmiller/nixos-configs` with essential DevOps tools while maintaining **Phase 2 architecture** (project-based development environments).

---

## Table of Contents

1. [Overview](#overview)
2. [Phase 2 Compliance](#phase-2-compliance)
3. [Implementation Steps](#implementation-steps)
   - [Step 1: Add DevOps Template](#step-1-add-devops-template)
   - [Step 2: Add dev-init Helper Script](#step-2-add-dev-init-helper-script)
   - [Step 3: Add Kubernetes Template](#step-3-add-kubernetes-template)
   - [Step 4: Add Terraform Template](#step-4-add-terraform-template)
   - [Step 5: Add CI/CD Template](#step-5-add-cicd-template)
   - [Step 6: Update System Packages (Minimal)](#step-6-update-system-packages-minimal)
   - [Step 7: Register Templates in Flake](#step-7-register-templates-in-flake)
4. [Testing](#testing)
5. [Usage Examples](#usage-examples)

---

## Overview

**Goal:** Add comprehensive DevOps tooling to `bydmiller/nixos-configs` while:
- ✅ Following Phase 2 architecture (no global development packages)
- ✅ Using project-specific flake templates
- ✅ Adding `dev-init` convenience wrapper
- ✅ Maintaining direnv integration
- ✅ Keeping system lean and fast

**What we're adding:**
- 5 new development templates (DevOps, Kubernetes, Terraform, CI/CD, Cloud)
- 1 helper script (`dev-init`)
- Minimal global tools (only CLIs, no heavy dependencies)

---

## Phase 2 Compliance

### ✅ Phase 2 Principles We're Following:

1. **Minimal System Packages** - Only essential CLIs globally
2. **Project-Specific Environments** - Heavy tools in flake templates
3. **Direnv Integration** - Automatic environment loading
4. **Template-Based** - Reusable development environments
5. **Isolated Dependencies** - No version conflicts

### ❌ What We're NOT Doing:

- ❌ Installing kubectl globally (use templates)
- ❌ Installing Terraform globally (use templates)
- ❌ Installing heavy cloud SDKs globally (use templates)
- ❌ Installing Ansible globally (use templates)

---

## Implementation Steps

### Step 1: Add DevOps Template

**File:** `flake-parts/templates/devops/flake.nix`

```nix
#
# DevOps Development Environment
#
# Includes: kubectl, helm, k9s, terraform, ansible, cloud CLIs, monitoring tools
#
{
  description = "Comprehensive DevOps Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # ============================================
            # TIER 1: Critical DevOps Tools
            # ============================================
            
            # Kubernetes Essentials
            kubectl              # Kubernetes CLI
            kubernetes-helm      # Helm package manager
            k9s                  # Terminal UI for K8s
            kubectx              # Switch between K8s contexts
            kubens               # Switch between K8s namespaces
            
            # Cloud Provider CLIs
            awscli2              # AWS CLI v2
            google-cloud-sdk     # GCP CLI (gcloud)
            azure-cli            # Azure CLI
            
            # Infrastructure as Code
            terraform            # Terraform
            opentofu             # OpenTofu (Terraform fork)
            ansible              # Configuration management
            packer               # Image builder
            
            # CI/CD
            gitlab-runner        # GitLab CI runner
            act                  # Run GitHub Actions locally
            
            # ============================================
            # TIER 2: Highly Recommended
            # ============================================
            
            # Container Tools
            podman-compose       # Docker Compose for Podman
            dive                 # Analyze Docker images
            hadolint             # Dockerfile linter
            skopeo               # Container image operations
            
            # Kubernetes Extras
            kind                 # Kubernetes in Docker
            kustomize            # K8s config customization
            stern                # Multi-pod log tailing
            kubeval              # Validate K8s manifests
            kubeseal             # Sealed Secrets
            
            # API & Data Tools
            httpie               # User-friendly HTTP client
            jq                   # JSON processor
            yq-go                # YAML processor
            fx                   # JSON viewer
            
            # Performance & Load Testing
            k6                   # Modern load testing
            vegeta               # HTTP load testing
            
            # Security & Scanning
            trivy                # Container vulnerability scanner
            checkov              # IaC security scanner
            tfsec                # Terraform security scanner
            
            # Backup & Storage
            restic               # Modern backup tool
            rclone               # Cloud storage sync
            
            # Network Tools
            mtr                  # Network diagnostics
            tcpdump              # Packet analyzer
            netcat               # TCP/UDP utility
            
            # Monitoring & Observability
            prometheus           # Metrics collection
            grafana              # Metrics visualization
            promtool             # Prometheus tooling
            
            # Git & Version Control
            git                  # Version control
            gh                   # GitHub CLI
            gitlab-cli           # GitLab CLI
            
            # Shell & Productivity
            direnv               # Environment switcher
            tmux                 # Terminal multiplexer
            fzf                  # Fuzzy finder
            ripgrep              # Fast grep
            bat                  # Cat with syntax highlighting
            eza                  # Modern ls
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║          🚀 DevOps Development Environment 🚀               ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 TIER 1 Tools (Critical):"
            echo "  • Kubernetes: kubectl, helm, k9s, kubectx"
            echo "  • Cloud: AWS, GCP, Azure CLIs"
            echo "  • IaC: Terraform, Ansible, Packer"
            echo "  • CI/CD: GitLab Runner, GitHub Actions"
            echo ""
            echo "🔧 TIER 2 Tools (Recommended):"
            echo "  • Containers: dive, hadolint, skopeo"
            echo "  • K8s Extras: kind, kustomize, stern"
            echo "  • Security: trivy, checkov, tfsec"
            echo "  • Testing: k6, vegeta"
            echo ""
            echo "📊 Version Information:"
            echo "  • kubectl:   $(kubectl version --client --short 2>/dev/null || echo 'N/A')"
            echo "  • terraform: $(terraform version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "  • ansible:   $(ansible --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo "  • aws:       $(aws --version 2>/dev/null | cut -d' ' -f1 | cut -d'/' -f2 || echo 'N/A')"
            echo ""
            echo "💡 Quick Start:"
            echo "  • kubectl get nodes          # List K8s nodes"
            echo "  • k9s                        # Launch K8s TUI"
            echo "  • terraform init             # Initialize Terraform"
            echo "  • ansible-playbook play.yml  # Run Ansible playbook"
            echo ""
            export PROJECT_ROOT=$PWD
          '';
        };
      });
}
```

**File:** `flake-parts/templates/devops/.envrc`

```bash
use flake
```

---

### Step 2: Add dev-init Helper Script

**File:** `homes/shared/programs/dev-init.nix`

```nix
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

      REPO="github:bydmiller/nixos-configs"
      
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
        echo -e "    pybind11-starter    Python + C++ bindings"
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
```

**File:** `homes/shared/programs/default.nix`

Add to imports:

```nix
{
  imports = [
    ./bat
    ./btop
    ./git
    ./yazi
    ./zellij

    ./dircolors.nix
    ./direnv.nix
    ./dev-init.nix        # <-- ADD THIS LINE
    ./editorconfig.nix
    ./eza.nix
    # ... rest of imports
  ];
}
```

---

### Step 3: Add Kubernetes Template

**File:** `flake-parts/templates/kubernetes/flake.nix`

```nix
#
# Kubernetes Development Environment
#
# Focused on K8s cluster management, manifest development, and debugging
#
{
  description = "Kubernetes Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Core K8s Tools
            kubectl
            kubernetes-helm
            k9s
            
            # Context & Namespace Management
            kubectx
            kubens
            
            # Local K8s Clusters
            kind
            minikube
            k3s
            
            # Manifest Tools
            kustomize
            kubeval
            kubeconform
            
            # Debugging & Logs
            stern
            kubectl-tree
            kubectl-images
            
            # Package Management
            helmfile
            
            # Security
            kubeseal
            kubescape
            
            # GitOps
            argocd
            fluxcd
            
            # Service Mesh
            istioctl
            linkerd
            
            # Utilities
            jq
            yq-go
            fzf
            
            # YAML linting
            yamllint
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         ☸️  Kubernetes Development Environment ☸️           ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • kubectl  $(kubectl version --client --short 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
            echo "  • helm     $(helm version --short 2>/dev/null | cut -d' ' -f1 | cut -d':' -f2 || echo 'N/A')"
            echo "  • k9s      $(k9s version --short 2>/dev/null || echo 'N/A')"
            echo ""
            echo "🔧 Available Commands:"
            echo "  • kubectl get nodes      - List cluster nodes"
            echo "  • k9s                    - Launch K8s TUI"
            echo "  • kubectx                - Switch K8s context"
            echo "  • kubens                 - Switch namespace"
            echo "  • stern <pod-pattern>    - Tail multiple pod logs"
            echo "  • kind create cluster    - Create local cluster"
            echo ""
            
            # Check current context
            if kubectl cluster-info &>/dev/null; then
              CURRENT_CONTEXT=$(kubectl config current-context)
              CURRENT_NS=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null || echo "default")
              echo "✅ Connected to cluster:"
              echo "   Context:   $CURRENT_CONTEXT"
              echo "   Namespace: $CURRENT_NS"
            else
              echo "⚠️  No active Kubernetes cluster detected"
              echo "   Run 'kind create cluster' to create a local cluster"
            fi
            echo ""
            
            export PROJECT_ROOT=$PWD
            export KUBECONFIG=''${KUBECONFIG:-$HOME/.kube/config}
          '';
        };
      });
}
```

**File:** `flake-parts/templates/kubernetes/.envrc`

```bash
use flake
```

---

### Step 4: Add Terraform Template

**File:** `flake-parts/templates/terraform/flake.nix`

```nix
#
# Terraform/IaC Development Environment
#
# Infrastructure as Code development with Terraform, OpenTofu, and related tools
#
{
  description = "Terraform/IaC Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Terraform
            terraform
            terraform-docs
            terraform-ls
            
            # OpenTofu (Terraform fork)
            opentofu
            
            # Linting & Security
            tflint
            tfsec
            checkov
            terrascan
            
            # State Management
            terraform-backend-git
            
            # Cloud Providers
            awscli2
            google-cloud-sdk
            azure-cli
            
            # Utilities
            jq
            yq-go
            graphviz  # For terraform graph
            
            # Version Management
            tfenv
            tgenv
            
            # Terragrunt
            terragrunt
            
            # Packer
            packer
            
            # Ansible
            ansible
            ansible-lint
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║         🏗️  Terraform/IaC Development Environment 🏗️        ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • Terraform: $(terraform version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "  • OpenTofu:  $(tofu version -json 2>/dev/null | jq -r '.terraform_version' || echo 'N/A')"
            echo "  • Packer:    $(packer version 2>/dev/null || echo 'N/A')"
            echo "  • Ansible:   $(ansible --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "🔧 Workflow Commands:"
            echo "  • terraform init         - Initialize working directory"
            echo "  • terraform plan         - Preview changes"
            echo "  • terraform apply        - Apply infrastructure changes"
            echo "  • terraform destroy      - Destroy infrastructure"
            echo ""
            echo "🔒 Security & Linting:"
            echo "  • tfsec .                - Security scan Terraform code"
            echo "  • tflint                 - Lint Terraform files"
            echo "  • checkov -d .           - Policy-as-code scanning"
            echo ""
            echo "📊 Documentation:"
            echo "  • terraform-docs md .    - Generate documentation"
            echo "  • terraform graph | dot -Tpng > graph.png  - Visualize dependencies"
            echo ""
            
            # Create .terraform.lock.hcl if it doesn't exist
            if [ ! -f ".terraform.lock.hcl" ] && [ -f "main.tf" ]; then
              echo "💡 Tip: Run 'terraform init' to initialize this Terraform project"
            fi
            echo ""
            
            export PROJECT_ROOT=$PWD
            export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
            mkdir -p "$TF_PLUGIN_CACHE_DIR"
          '';
        };
      });
}
```

**File:** `flake-parts/templates/terraform/.envrc`

```bash
use flake
```

---

### Step 5: Add CI/CD Template

**File:** `flake-parts/templates/cicd/flake.nix`

```nix
#
# CI/CD Development Environment
#
# Tools for continuous integration and deployment pipelines
#
{
  description = "CI/CD Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # GitHub Actions
            act                   # Run GitHub Actions locally
            gh                    # GitHub CLI
            
            # GitLab CI
            gitlab-runner         # GitLab CI runner
            glab                  # GitLab CLI
            
            # Jenkins
            jenkins
            
            # Container Building
            kaniko                # Build containers in K8s
            buildah               # Build OCI containers
            skopeo                # Container operations
            
            # Linting & Quality
            yamllint              # YAML linter
            actionlint            # GitHub Actions linter
            hadolint              # Dockerfile linter
            shellcheck            # Shell script linter
            
            # Security Scanning
            trivy                 # Container vulnerability scanner
            grype                 # Container vulnerability scanner
            syft                  # SBOM generator
            
            # Testing & Validation
            bats                  # Bash testing framework
            k6                    # Load testing
            
            # Secrets Management
            sops                  # Secrets encryption
            age                   # Encryption tool
            
            # Utilities
            jq
            yq-go
            git
            curl
            
            # Notification Tools
            ntfy-sh               # Push notifications
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║            🔄 CI/CD Development Environment 🔄               ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Installed Tools:"
            echo "  • act (GitHub Actions):  $(act --version 2>/dev/null | head -n1 || echo 'N/A')"
            echo "  • gitlab-runner:         $(gitlab-runner --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo "  • trivy:                 $(trivy --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo 'N/A')"
            echo ""
            echo "🔧 GitHub Actions:"
            echo "  • act                    - Run GitHub Actions locally"
            echo "  • act -l                 - List available workflows"
            echo "  • act push               - Simulate push event"
            echo ""
            echo "🔧 GitLab CI:"
            echo "  • gitlab-runner exec docker <job>  - Run GitLab CI job locally"
            echo "  • glab ci view           - View pipeline status"
            echo ""
            echo "🔒 Security Scanning:"
            echo "  • trivy image <image>    - Scan container image"
            echo "  • trivy fs .             - Scan filesystem"
            echo "  • hadolint Dockerfile    - Lint Dockerfile"
            echo ""
            echo "✅ Linting:"
            echo "  • actionlint             - Lint GitHub Actions"
            echo "  • yamllint .             - Lint YAML files"
            echo "  • shellcheck script.sh   - Lint shell scripts"
            echo ""
            
            export PROJECT_ROOT=$PWD
            
            # Check for common CI files
            if [ -d ".github/workflows" ]; then
              echo "✅ Found GitHub Actions workflows"
              echo "   Run 'act -l' to list available workflows"
            fi
            
            if [ -f ".gitlab-ci.yml" ]; then
              echo "✅ Found GitLab CI configuration"
            fi
            
            if [ -f "Jenkinsfile" ]; then
              echo "✅ Found Jenkinsfile"
            fi
            echo ""
          '';
        };
      });
}
```

**File:** `flake-parts/templates/cicd/.envrc`

```bash
use flake
```

---

### Step 6: Add Cloud Template

**File:** `flake-parts/templates/cloud/flake.nix`

```nix
#
# Multi-Cloud Development Environment
#
# CLIs for AWS, GCP, Azure, and other cloud providers
#
{
  description = "Multi-Cloud Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # AWS
            awscli2
            aws-vault
            awslogs
            ec2-instance-selector
            
            # Google Cloud
            google-cloud-sdk
            
            # Azure
            azure-cli
            
            # DigitalOcean
            doctl
            
            # Linode
            linode-cli
            
            # Hetzner
            hcloud
            
            # Oracle Cloud
            oci-cli
            
            # Multi-Cloud Tools
            pulumi
            terraform
            
            # Kubernetes (cloud-native)
            kubectl
            kubernetes-helm
            
            # Storage & Backup
            rclone
            restic
            
            # Utilities
            jq
            yq-go
            fzf
            
            # Network Tools
            curl
            httpie
            netcat
          ];

          shellHook = ''
            echo "╔══════════════════════════════════════════════════════════════╗"
            echo "║           ☁️  Multi-Cloud Development Environment ☁️        ║"
            echo "╚══════════════════════════════════════════════════════════════╝"
            echo ""
            echo "📦 Cloud Provider CLIs:"
            echo "  • AWS:             $(aws --version 2>&1 | cut -d' ' -f1 | cut -d'/' -f2 || echo 'N/A')"
            echo "  • GCP:             $(gcloud version 2>/dev/null | head -n1 | cut -d' ' -f4 || echo 'N/A')"
            echo "  • Azure:           $(az version 2>/dev/null | jq -r '."azure-cli"' || echo 'N/A')"
            echo "  • DigitalOcean:    $(doctl version 2>/dev/null | cut -d' ' -f3 || echo 'N/A')"
            echo ""
            echo "🔧 Quick Start:"
            echo ""
            echo "  AWS:"
            echo "    aws configure                    - Configure AWS credentials"
            echo "    aws s3 ls                        - List S3 buckets"
            echo "    aws ec2 describe-instances       - List EC2 instances"
            echo ""
            echo "  GCP:"
            echo "    gcloud init                      - Initialize gcloud"
            echo "    gcloud compute instances list    - List compute instances"
            echo "    gcloud container clusters list   - List GKE clusters"
            echo ""
            echo "  Azure:"
            echo "    az login                         - Login to Azure"
            echo "    az vm list                       - List VMs"
            echo "    az aks list                      - List AKS clusters"
            echo ""
            echo "💡 Credential Management:"
            echo "  • AWS credentials:    ~/.aws/credentials"
            echo "  • GCP credentials:    gcloud auth login"
            echo "  • Azure credentials:  az login"
            echo ""
            
            export PROJECT_ROOT=$PWD
            
            # Check for cloud credentials
            if [ -f "$HOME/.aws/credentials" ]; then
              echo "✅ AWS credentials found"
            fi
            
            if gcloud auth list --filter=status:ACTIVE 2>/dev/null | grep -q ACTIVE; then
              echo "✅ GCP credentials found"
            fi
            
            if az account show &>/dev/null; then
              echo "✅ Azure credentials found"
            fi
            echo ""
          '';
        };
      });
}
```

**File:** `flake-parts/templates/cloud/.envrc`

```bash
use flake
```

---

### Step 7: Update System Packages (Minimal)

**File:** `modules/shared/environment/packages.nix`

```nix
{
  pkgs,
  lib,
  ...
}: {
  environment = {
    defaultPackages = lib.mkForce [];
    systemPackages = with pkgs; [
      # Core utilities (existing)
      git
      curl
      wget
      pciutils
      lshw
      bind.dnsutils
      
      # DevOps essentials (ONLY lightweight CLIs)
      # Heavy tools go in project templates
      direnv         # Environment switcher (essential for Phase 2)
      jq             # JSON processor (used everywhere)
      yq-go          # YAML processor (used everywhere)
    ];
  };
}
```

**Rationale:** Only add `direnv`, `jq`, and `yq-go` globally because:
- They're lightweight (<10MB each)
- Used by every template
- Essential for Phase 2 workflow
- No version conflicts

---

### Step 8: Register Templates in Flake

**File:** `flake-parts/templates/default.nix`

```nix
_: {
  flake.templates = {
    # Existing templates...
    python = {
      path = ./python;
      description = "Python Development environment";
    };

    torch-basics = {
      path = ./ml/torch-basics;
      description = "A template for a basic machine learning project with PyTorch";
    };

    cpp-starter-kit = {
      path = ./ml/cpp-starter-kit;
      description = "A template for a c++ development project skeleton with CMake";
    };

    js-webapp-basics = {
      path = ./ml/js-webapp-basics;
      description = "A template for creating javascript/typescript web application development environment";
    };

    langchain-basics = {
      path = ./ml/langchain-basics;
      description = "A template for creating a langchain based LLM application";
    };

    pybind11-starter-kit = {
      path = ./ml/pybind11-starter-kit;
      description = "A template that creates a skeleton for a pybind11 module, including development environment and nix packaging";
    };

    maturin-basics = {
      path = ./ml/maturin-basics;
      description = "A template as the starting point for building a pyo3 (rust) based python package.";
    };

    c = {
      path = ./c;
      description = "Development environment for C/C++";
    };

    rust = {
      path = ./rust;
      description = "Development environment for Rust";
    };

    node = {
      path = ./node;
      description = "Development environment for NodeJS";
    };

    go = {
      path = ./go;
      description = "Development environment for Golang";
    };

    java = {
      path = ./java;
      description = "Development environment for Java";
    };

    php = {
      path = ./php;
      description = "Development environment for PHP";
    };

    # ========================================
    # NEW DEVOPS TEMPLATES
    # ========================================

    devops = {
      path = ./devops;
      description = "Comprehensive DevOps environment with kubectl, terraform, ansible, cloud CLIs, and monitoring tools";
    };

    kubernetes = {
      path = ./kubernetes;
      description = "Kubernetes development environment with kubectl, helm, k9s, and cluster management tools";
    };

    terraform = {
      path = ./terraform;
      description = "Terraform/IaC environment with terraform, opentofu, tfsec, and cloud provider CLIs";
    };

    cicd = {
      path = ./cicd;
      description = "CI/CD pipeline development with GitHub Actions, GitLab CI, and container security scanning";
    };

    cloud = {
      path = ./cloud;
      description = "Multi-cloud development environment with AWS, GCP, Azure, and DigitalOcean CLIs";
    };
  };
}
```

---

## Testing

### Test 1: Verify Templates Available

```bash
# After rebuilding your system
nix flake show github:bydmiller/nixos-configs

# Should show new templates:
# ├───templates
# │   ├───devops: template: Comprehensive DevOps environment...
# │   ├───kubernetes: template: Kubernetes development environment...
# │   ├───terraform: template: Terraform/IaC environment...
# │   ├───cicd: template: CI/CD pipeline development...
# │   └───cloud: template: Multi-cloud development environment...
```

### Test 2: Verify dev-init Script

```bash
# After home-manager switch
dev-init

# Should show colorful menu with all templates
```

### Test 3: Test DevOps Template

```bash
mkdir ~/test-devops
cd ~/test-devops

dev-init devops

# Should create:
# - flake.nix
# - .envrc

# Verify environment
kubectl version --client
terraform version
ansible --version
aws --version
```

### Test 4: Test Kubernetes Template

```bash
mkdir ~/test-k8s
cd ~/test-k8s

dev-init kubernetes

# Verify K8s tools
kubectl version --client
helm version
k9s version
```

### Test 5: Test Environment Isolation

```bash
# Outside project - kubectl should NOT be available
cd ~
kubectl version 2>&1 | grep "command not found"  # Should fail

# Inside project - kubectl should be available
cd ~/test-k8s
kubectl version --client  # Should work
```

---

## Usage Examples

### Example 1: Start a New Kubernetes Project

```bash
# Create project
mkdir my-k8s-cluster
cd my-k8s-cluster

# Initialize environment
dev-init kubernetes

# Environment loads automatically via direnv
# Output:
# ╔══════════════════════════════════════════════════════════════╗
# ║         ☸️  Kubernetes Development Environment ☸️           ║
# ╚═══��══════════════════════════════════════════════════════════╝

# Create local cluster
kind create cluster --name dev

# Deploy something
kubectl create deployment nginx --image=nginx
kubectl get pods
```

### Example 2: Terraform Infrastructure Project

```bash
# Create project
mkdir my-infrastructure
cd my-infrastructure

# Initialize environment
dev-init terraform

# Create Terraform files
cat > main.tf <<EOF
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
EOF

# Work with Terraform
terraform init
terraform plan
tfsec .  # Security scan
```

### Example 3: Multi-Cloud Management

```bash
# Create project
mkdir cloud-management
cd cloud-management

# Initialize environment
dev-init cloud

# Configure AWS
aws configure

# Configure GCP
gcloud init

# Configure Azure
az login

# Now all CLIs available in one environment
aws s3 ls
gcloud compute instances list
az vm list
```

### Example 4: CI/CD Pipeline Development

```bash
# Create project
mkdir my-pipeline
cd my-pipeline

# Initialize environment
dev-init cicd

# Create GitHub Actions workflow
mkdir -p .github/workflows
cat > .github/workflows/test.yml <<EOF
name: Test
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: echo "Testing"
EOF

# Test workflow locally
act -l  # List workflows
act push  # Run push event

# Lint workflow
actionlint
```

### Example 5: Full DevOps Stack

```bash
# Create project
mkdir my-devops-project
cd my-devops-project

# Initialize comprehensive environment
dev-init devops

# Everything is available:
kubectl version --client
terraform version
ansible --version
aws --version
helm version
k9s version
trivy --version
```

---

## Verification Checklist

After completing all steps, verify:

- [ ] `dev-init` command available globally
- [ ] `dev-init` shows colorful help menu
- [ ] All 5 new templates listed in `nix flake show`
- [ ] DevOps template creates working environment
- [ ] Kubernetes template creates working environment
- [ ] Terraform template creates working environment
- [ ] CI/CD template creates working environment
- [ ] Cloud template creates working environment
- [ ] direnv automatically loads environments
- [ ] direnv automatically unloads when leaving directory
- [ ] No kubectl/terraform/ansible in global PATH
- [ ] System rebuild is still fast (<5 minutes)
- [ ] Phase 2 principles maintained

---

## File Structure Summary

```
bydmiller/nixos-configs/
├── flake-parts/
│   └── templates/
│       ├── default.nix                    # MODIFIED: Add new templates
│       ├── devops/
│       │   ├── flake.nix                  # NEW: DevOps template
│       │   └── .envrc                     # NEW
│       ├── kubernetes/
│       │   ├── flake.nix                  # NEW: K8s template
│       │   └── .envrc                     # NEW
│       ├── terraform/
│       │   ├── flake.nix                  # NEW: Terraform template
│       │   └── .envrc                     # NEW
│       ├── cicd/
│       │   ├── flake.nix                  # NEW: CI/CD template
│       │   └── .envrc                     # NEW
│       └── cloud/
│           ├── flake.nix                  # NEW: Cloud template
│           └── .envrc                     # NEW
│
├── homes/shared/programs/
│   ├── default.nix                        # MODIFIED: Add dev-init import
│   └── dev-init.nix                       # NEW: Helper script
│
└── modules/shared/environment/
    └── packages.nix                       # MODIFIED: Add jq, yq-go, direnv
```

---

## Rebuild Commands

```bash
# 1. Rebuild system (adds jq, yq-go, direnv globally)
sudo nixos-rebuild switch --flake ~/nixos-configs#<hostname>

# 2. Rebuild home-manager (adds dev-init script)
home-manager switch --flake ~/nixos-configs#<user>@<hostname>

# 3. Verify installation
dev-init
nix flake show ~/nixos-configs
```

---

## Benefits Achieved

✅ **Phase 2 Compliant:**
- No heavy tools globally
- Fast system rebuilds
- Isolated project environments

✅ **DevOps Ready:**
- All TIER 1 & TIER 2 tools available
- Kubernetes ecosystem complete
- Multi-cloud support
- CI/CD capabilities

✅ **User Friendly:**
- Simple `dev-init` command
- Automatic environment loading
- Helpful documentation in shell hooks
- Easy to discover templates

✅ **Maintainable:**
- Modular template structure
- Easy to add new templates
- Clear separation of concerns

---

## Next Steps

1. Fork `bydmiller/nixos-configs`
2. Create all new files listed above
3. Test each template
4. Submit pull request
5. Enjoy comprehensive DevOps tooling! 🚀
