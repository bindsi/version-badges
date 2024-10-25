# Need for a CLI to drive project value

Date: **2021-10-14** [Format=YYYY-MM-DD]

## Status

- [ ] Draft
- [X] Proposed
- [ ] Accepted
- [ ] Deprecated
- [ ] Superseded by 0002

## Decision

Determine the minimum initial scope of this project to deliver value to and accelerate ISE crews building edge computing systems.

## Context

Azure IoT Operations is a relatively fresh set of middleware solutions for building scalable and robust edge computing systems, however the product suite is nascent and still under heavy development. Customers building edge computing solutions have wide arrangements of internal stakeholders that work to perform the similar tasks of solution provisioning. In some customer organizations, corporate IT does physical, on-prem hardware provisioning, in other organizations physical hardware provisioning requires on-prem and corporate network engineers, on-prem and enterprise IT staff, security teams, DevOps/Platform teams, centralized subscription management and compliance teams, etc.

## Decision drivers (optional)

- (As noted above) Customers building edge computing solutions have wide arrangements of internal stakeholders that work to perform the similar tasks of solution provisioning. In some customer organizations, corporate IT does physical, on-prem hardware provisioning, in other organizations physical hardware provisioning requires on-prem and corporate network engineers, on-prem and enterprise IT staff, security teams, DevOps/Platform teams, centralized subscription management and compliance teams, etc.
- ISE crews can already copy and modify existing solutions for Chevron, Kraft, KHI, Flextronics.
- Evaluation of new PG products and offerings and their fitness to task is critical to close known and unknown product gaps for customers. Expediting the time to evaluation is critical.
- Currently, AIO requires highly elevated privileges to deploy and the opportunity to cross examine, through segmentation of solution setup by role, will expose weaknesses in privilege requirements and will drive feedback to improve PG products and offerings.

## Considered options (optional)

- Sharing existing assets directly with some generalization (e.g. no new development/continued crew asset sharing)
- Idiomatic solutions custom tailored for both Bicep and Terraform
- Creating a CLI tool to generate custom layered IaC

A singular "lump" of images, scripts, and IaC (e.g. taken from an engagement and generalized) would need to be sliced up by hand and provided to customer stakeholders manually, to meet each organization where they are and how they are structured. This approach would likely result in either redundant contributions (similar content but sliced differently) or no contribution back into the project (for large change differential making merges challenging).

Idiomatic solutions custom tailored for both Bicep and Terraform are an option, however keeping them perfectly in lockstep over time will prove challenging. Conversely, taking this approach would yield more optimized end-state IaC, and likely expedite inbound contributions, as contributing developers would not need to be familiar with both Bicep and Terraform, and need the skill sets required for generalization across both approaches.

A CLI tool is a significant commitment of work, but will likely drive increased generalization and abstraction over simple direct asset sharing from engagements. Having the flexibility to layer and slice images, scripts, and Iac by customer role and target environment. This also allows for the creation of "solutions" that provide different compositions of cloud and edge components. Given that the base IaC, scripts, and images can be extracted from inflight engagements, development work can be focused on creating the solution abstraction, and output layers. Further the next year of AIO development roadmap, will include updates to the underlying IaC on about a monthly cadence. The CLI approach may expedite uniformity of across Terraform and Bicep as this solution snaps to AE&P's AIO release cadence.

## Decision Conclusion

AI on the Edge's IaC project will take on the building and maintainence of a CLI to accelerate ISE crews engaged in edge computing projects.  

## Consequences

We will be committing to an additional layer of software (and its backing development effort) at a very early point in the innovation cycle. We are also lightly staffed for this work, adding to the total complexity of getting to an MVP.
