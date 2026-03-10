# tf-module-generator

![Audit](https://img.shields.io/badge/audit%3A%20FAIL-red) ![License](https://img.shields.io/badge/license-MIT-blue) ![OpenClaw](https://img.shields.io/badge/OpenClaw-skill-orange)

> Automatically generates Terraform modules from existing cloud infrastructure resources with intelligent resource detection and best-practice code formatting.

## Description

Automatically generates Terraform modules from existing cloud infrastructure resources across AWS, Azure, and GCP. The skill discovers live cloud resources, creates optimized Terraform code with proper variable definitions and outputs, and validates the generated modules against Terraform best practices.

## Features

- Scan and analyze existing cloud infrastructure resources across AWS, Azure, and GCP
- Generate optimized Terraform module code with proper variable definitions and outputs
- Support multiple resource types (compute, storage, networking, databases, etc.)
- Generate documentation and example usage for each generated module
- Validate generated Terraform syntax and best practices
- Provide CLI interface with customizable output options and error handling
- Integrate seamlessly with OpenClaw agent workflows for automated infrastructure management

## Requirements

- Cloud provider credentials configured (AWS CLI, Azure CLI, or GCP CLI)
- Node.js 18+ runtime
- Access to `terraform` binary for validation (optional but recommended)
- OpenCl agent with sessions_spawn capability

## GitHub

Source code: [github.com/NeoSkillFactory/tf-module-generator](https://github.com/NeoSkillFactory/tf-module-generator)

## License

MIT © NeoSkillFactory