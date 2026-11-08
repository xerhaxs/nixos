# office

## Purpose

Office, documents, finance.

## How it works

- LibreOffice with dictionaries and LanguageTool (own server), LaTeX (Kile, TeX Live), Okular, OCR and scanning, KMyMoney with AqBanking, Monero GUI (own local node, mining through P2Pool from the GUI), Bisq.

## Contents

| Path | Description |
|---|---|
| `default.nix` | Imports the modules of this folder and defines the bundle option `homeManager.applications.office.enable`. |
| `financial.nix` | Enable financial tools. |
| `kile.nix` | Enable kile |
| `kmymoney.nix` | Enable kmymoney |
| `office.nix` | Enable office tools. |
| `okular.nix` | Enable okular. |
| `skanpage.nix` | Enable skanpage. |

## Options

| Option | Type | Default | Description |
|---|---|---|---|
| `homeManager.applications.office.enable` | boolean | `false` | Enable office modules bundle. |
| `homeManager.applications.office.financial.enable` | boolean | `false` | Enable financial tools. |
| `homeManager.applications.office.kile.enable` | boolean | `false` | Enable kile |
| `homeManager.applications.office.kmymoney.enable` | boolean | `false` | Enable kmymoney |
| `homeManager.applications.office.office.enable` | boolean | `false` | Enable office tools. |
| `homeManager.applications.office.okular.enable` | boolean | `false` | Enable okular. |
| `homeManager.applications.office.skanpage.enable` | boolean | `false` | Enable skanpage. |
