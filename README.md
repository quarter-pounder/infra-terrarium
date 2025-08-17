# infra-terrarium
*a modular, disposable testbed for infra sanity checks, logs, and observability*

---

## What's This?

`infra-terrarium` is a "we have infrastructure at home" kind of project, aiming to spin up cloud-based environments — fast, repeatable, and close enough to production — so I can test infrastructure setups, log pipelines, monitoring agents, and behavior **under real conditions**, not just stubs.

I need it because **logs and observability mean nothing on bare metal**. You can spin up Loki and Grafana all you want — but if there’s no legit noise, no actual clock drift, no platform divergence, it’s just static. I want this repo to give me a base where I can plug in whatever I’m working on, or tear it all down without hesitation.

---

## Goals

- [x] Set up this repo and write the damn README
- [ ] Support minimal Linux VMs using IaC (Terraform module)
- [ ] Provide an optional “fake Windows” box (Linux pretending to be Windows, logs included)
- [ ] Scripted apply/destroy helpers (not everyone loves raw `terraform`, well, I don't)
- [ ] Make it plug-and-play: log agents, exporters... and whatever I will come up with
- [ ] No local setup. Cloud only.
- [ ] Optional: Real Windows config set, for when I actually need it
- [ ] Time sync (NTP) — because log timestamps out of sync are useless
- [ ] Basic log emitters — noisy enough to matter, not noisy enough to drown
- [ ] Observability stack module (Loki, Alloy, Grafana) — addable, not mandatory
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

## Setup (To be added)

- Terraform ≥ 1.4
- Bash, curl, sanity
- Cloud provider access (AWS, etc.)
- Mock credentials later for tests

---

## About “Fake Windows”

Yes, I hate Windows — but sometimes you need to know how it behaves.
Instead of burning budget unnecessarily, I’ll mock a Windows node with:
- PowerShell Core on Linux
- Simulated EventLog entries
- A hostname that *smells* like Windows
- Optional WinRM port dummy

If I ever need real Windows: I’ll make a dedicated config for it, isolated from the rest.

---

## Notes to Future Me

- Don’t overengineer. Add only what you need.
- Keep modules small, clean, and composable.
- Every log/metric should be timestamp-accurate. NTP or bust.
- This is for me — but others might use it later, so write legibly.

---

## Roadmap (Rough sketch)

- [ ] `modules/core-linux/` with basic cloud-init
- [ ] `modules/core-fake-windows/` with log emitter
- [ ] `scripts/apply.sh`, `destroy.sh`
- [ ] `configs/linux/config.alloy`, `node_exporter.service`
- [ ] `modules/observability/` with Grafana/Loki stack
- [ ] `environments/test/` with 2 Linux + 1 fake Win + optional stress
- [ ] Optional chaos module (clock skew, log delay, network flap)

---

## License

MIT — do what you want, break it if you must, fix it if you're feeling generous.
