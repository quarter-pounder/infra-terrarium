# infra-terrarium
*a modular, disposable testbed for infra sanity checks, logs, and observability*

---

## What's This?

`infra-terrarium` is a "we have infrastructure at home" kind of project, aiming to spin up cloud-based environments: fast, repeatable, and close enough to production, so I can test infrastructure setups, log pipelines, monitoring agents, and behavior **under real conditions**, not just stubs.

I need it because **logs and observability mean nothing on bare metal**. You can spin up Loki and Grafana all you want, but if there's no legit noise, no actual clock drift, no platform divergence, it's just static. I want this repo to give me a base where I can plug in whatever I'm working on, or tear it all down without hesitation.

---

## Goals

- [x] Set up this repo and write the damn README
- [x] Support minimal Linux VMs using IaC (Terraform module)
- [ ] Provide an optional "fake Windows" box (Linux pretending to be Windows, logs included)
- [x] Scripted apply/destroy helpers (not everyone loves raw `terraform`, well, I don't)
- [x] Make it plug-and-play: log agents, exporters... and whatever I will come up with
- [x] No local setup. Cloud only.
- [ ] Optional: Real Windows config set, for when I actually need it
- [x] Time sync (NTP). Because log timestamps out of sync are useless
- [ ] Basic log emitters. Noisy enough to matter, not noisy enough to drown
- [x] Observability stack module (Loki, Alloy, Grafana)
- [ ] Play well with other projects (eventually plug into real apps, or stress/load scripts)

---

## Structure (WIP)

```
infra-terrarium/
├── modules/              # Reusable Terraform modules (core-linux, fake-win, etc.)
├── environments/
│   └── dev/              # Default sandbox setup
├── scripts/              # Apply / destroy helpers
├── configs/               # Versioned setup files (cloud-init, alloy, etc.)
│   ├── linux/
│   ├── windows/
│   └── shared/
├── .env.example          # For cloud provider config
├── .gitignore
└── README.md             # This file: intro + notes + to-do tracker
```

---

## Setup

**Prerequisites:**
- Terraform ≥ 1.4
- AWS account with programmatic access
- AWS CLI configured (or environment variables set)
- SSH key pair created in AWS (EC2 Key Pairs)
- SSH public key file locally (default: `~/.ssh/terrarium-key.pub`)

**Configuration:**
1. Configure AWS credentials (choose one):
   - Set environment variables: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`
   - Use AWS CLI profile: `aws configure --profile terrarium`
   - Create `terraform.tfvars` (gitignored) with credentials (see `.env.example`)

2. Ensure SSH key pair exists in AWS (same region as deployment)

3. Optionally customize variables in `environments/dev/variables.tf` or via `terraform.tfvars`

---

## Quick Start

**Deploy infrastructure:**
```bash
./scripts/apply.sh
```

This will:
- Initialize Terraform
- Validate configuration
- Deploy a Linux VM with Alloy, NTP, and basic observability
- Display instance details and SSH command

**Connect to instance:**
```bash
# Get SSH command from outputs
cd environments/dev
terraform output ssh_command

# Or use the displayed command from apply.sh output
```

**Destroy infrastructure:**
```bash
./scripts/destroy.sh
```

**Current deployment:**
- Single Ubuntu 22.04 VM (`t3.micro`)
- Default VPC/subnet (configurable via variables)
- Security group with SSH access (port 22)
- Alloy agent installed and configured
- NTP (chrony) enabled for time sync
- Host metrics collection (node exporter)
- Syslog and auth.log collection

---

## About "Fake Windows"

Yes, I hate Windows. But sometimes you need to know how it behaves.
Instead of burning budget unnecessarily, I'll mock a Windows node with:
- PowerShell Core on Linux
- Simulated EventLog entries
- A hostname that *smells* like Windows
- Optional WinRM port dummy

If I ever need real Windows: I'll make a dedicated config for it, isolated from the rest.

---

## Notes to Future Me

- Don't overengineer. Add only what you need.
- Keep modules small, clean, and composable.
- Every log/metric should be timestamp-accurate. NTP or bust.
- This is for me, but others might use it later, so write legibly.

---

## Roadmap (Rough sketch)

- [x] `modules/core-linux/` with basic cloud-init
- [ ] `modules/core-fake-windows/` with log emitter
- [x] `scripts/apply.sh`, `destroy.sh`
- [x] `configs/linux/config.alloy`, host metrics collection
- [ ] `modules/observability/` with Grafana/Loki stack (standalone)
- [ ] `environments/test/` with 2 Linux + 1 fake Win + optional stress
- [ ] Optional chaos module (clock skew, log delay, network flap)
- [x] VPC/subnet support with automatic defaults

---

## License

MIT — do what you want, break it if you must, fix it if you're feeling generous.
