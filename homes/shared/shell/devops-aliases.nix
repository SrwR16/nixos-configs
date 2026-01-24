#
# DevOps Shell Aliases - Productivity Shortcuts
#
# Convenient abbreviations and aliases for common DevOps workflows.
# Compatible with zsh and bash shells.
#
{ config, lib, ... }:

{
  programs.zsh.shellAliases = lib.mkIf config.programs.zsh.enable {
    # ========================================
    # Kubernetes Shortcuts
    # ========================================
    
    k = "kubectl";
    
    # Get resources
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kgi = "kubectl get ingress";
    kgn = "kubectl get nodes";
    kga = "kubectl get all";
    kgns = "kubectl get namespaces";
    
    # Describe resources
    kdp = "kubectl describe pod";
    kds = "kubectl describe service";
    kdd = "kubectl describe deployment";
    
    # Apply and delete
    kaf = "kubectl apply -f";
    kdel = "kubectl delete";
    kdelf = "kubectl delete -f";
    
    # Logs and exec
    klog = "kubectl logs -f";
    kexec = "kubectl exec -it";
    
    # Context and namespace
    kctx = "kubectx";
    kns = "kubens";
    
    # Port forwarding
    kpf = "kubectl port-forward";
    
    # Scale resources
    kscale = "kubectl scale";
    
    # ========================================
    # Docker & Container Shortcuts
    # ========================================
    
    dc = "docker-compose";
    dcu = "docker-compose up -d";
    dcd = "docker-compose down";
    dcl = "docker-compose logs -f";
    dcr = "docker-compose restart";
    
    # Docker commands
    dps = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
    dpsa = "docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
    di = "docker images";
    drmi = "docker rmi";
    drmv = "docker volume rm";
    drmf = "docker system prune -f";
    drmaf = "docker system prune -af";
    
    # Docker exec
    dex = "docker exec -it";
    
    # Docker logs
    dlog = "docker logs -f";
    
    # Podman equivalents
    pc = "podman-compose";
    pcu = "podman-compose up -d";
    pcd = "podman-compose down";
    pps = "podman ps";
    
    # ========================================
    # Terraform Shortcuts
    # ========================================
    
    tf = "terraform";
    tfi = "terraform init";
    tfp = "terraform plan";
    tfa = "terraform apply";
    tfaa = "terraform apply -auto-approve";
    tfd = "terraform destroy";
    tfs = "terraform state list";
    tfo = "terraform output";
    tfv = "terraform validate";
    tff = "terraform fmt";
    
    # Terragrunt
    tg = "terragrunt";
    tgi = "terragrunt init";
    tgp = "terragrunt plan";
    tga = "terragrunt apply";
    tgaa = "terragrunt apply -auto-approve";
    tgd = "terragrunt destroy";
    
    # ========================================
    # Ansible Shortcuts
    # ========================================
    
    ans = "ansible";
    ansp = "ansible-playbook";
    ansi = "ansible-inventory";
    ansv = "ansible-vault";
    ansg = "ansible-galaxy";
    
    # ========================================
    # Git Workflow Shortcuts
    # ========================================
    
    gs = "git status -sb";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -m";
    gca = "git commit --amend";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gl = "git pull";
    gco = "git checkout";
    gcb = "git checkout -b";
    gb = "git branch -v";
    gbd = "git branch -d";
    gm = "git merge";
    gr = "git rebase";
    gri = "git rebase -i";
    gst = "git stash";
    gstp = "git stash pop";
    gd = "git diff";
    gdc = "git diff --cached";
    glog = "git log --oneline --graph --decorate";
    gloga = "git log --oneline --graph --decorate --all";
    
    # ========================================
    # NixOS Shortcuts
    # ========================================
    
    nrs = "sudo nixos-rebuild switch --flake .";
    nrb = "nixos-rebuild build --flake .";
    nrt = "nixos-rebuild test --flake .";
    
    hms = "home-manager switch --flake .";
    hmb = "home-manager build --flake .";
    
    nfu = "nix flake update";
    nfc = "nix flake check";
    nfs = "nix flake show";
    
    ngc = "nix-collect-garbage -d";
    ngcs = "sudo nix-collect-garbage -d";
    
    # ========================================
    # Monitoring & System Info
    # ========================================
    
    ports = "ss -tuln";
    myip = "curl -s ipinfo.io/ip";
    weather = "curl -s wttr.in";
    
    # ========================================
    # JSON/YAML Tools
    # ========================================
    
    json = "jq";
    yaml = "yq";
    yamllint-all = "yamllint .";
    
    # ========================================
    # Helm Shortcuts
    # ========================================
    
    h = "helm";
    hi = "helm install";
    hu = "helm upgrade";
    hls = "helm list";
    hs = "helm search";
    
    # ========================================
    # Utility Functions
    # ========================================
    
    # Quick file search
    f = "find . -name";
    
    # Process search
    psg = "ps aux | grep -v grep | grep -i -e VSZ -e";
    
    # Disk usage
    duh = "du -h --max-depth=1 | sort -hr";
  };

  # Additional bash aliases (for compatibility)
  programs.bash.shellAliases = lib.mkIf config.programs.bash.enable {
    # Core shortcuts that work in bash
    k = "kubectl";
    dc = "docker-compose";
    tf = "terraform";
    gs = "git status -sb";
    nrs = "sudo nixos-rebuild switch --flake .";
    hms = "home-manager switch --flake .";
    
    # Kubernetes
    kgp = "kubectl get pods";
    kgs = "kubectl get services";
    kgd = "kubectl get deployments";
    kga = "kubectl get all";
    kaf = "kubectl apply -f";
    klog = "kubectl logs -f";
    kexec = "kubectl exec -it";
    
    # Docker
    dps = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
    dcu = "docker-compose up -d";
    dcd = "docker-compose down";
    
    # Terraform
    tfi = "terraform init";
    tfp = "terraform plan";
    tfa = "terraform apply";
    
    # Git
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit -m";
    gp = "git push";
    gl = "git pull";
    gco = "git checkout";
    gcb = "git checkout -b";
    gd = "git diff";
    glog = "git log --oneline --graph --decorate";
    
    # NixOS
    nfu = "nix flake update";
    nfc = "nix flake check";
    nfs = "nix flake show";
    ngc = "nix-collect-garbage -d";
  };
}
