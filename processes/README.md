# BPMN Processes for GridFlow

This directory contains BPMN 2.0 process definitions for the PV registration system.

## Process Files

### pv-registration-process.bpmn
Main process for PV system registration following VDE-AR-N 4105 standards.

**Process Steps:**
1. **Start PV Registration** - User initiates the registration process
2. **Enter PV System Details** - User provides system specifications
3. **Upload Meter Cabinet Photos** - User uploads documentation
4. **AI Meter Cabinet Analysis** - Automated compliance checking
5. **Is Compliant?** - Decision gateway based on AI analysis
   - If compliant: Proceed to VNB submission
   - If not compliant: Manual review required
6. **Submit to Grid Operator (VNB)** - Send application to utility
7. **Wait for VNB Approval** - Track approval status
8. **Registration Complete** - Process ends

## Forms

Form schemas are located in the `forms/` directory:
- `pv-system-details-schema.json` - JSON Schema for system details form

## Usage with SpiffArena

These BPMN files are designed to work with SpiffWorkflow/SpiffArena:
1. Files in this directory are shared via Docker volume
2. SpiffArena can import and execute these processes
3. Forms are rendered based on JSON schemas
4. Service tasks integrate with api-gateway and ai-service

## Development

To edit BPMN diagrams:
1. Use Camunda Modeler (recommended)
2. Use bpmn.io web modeler
3. Edit XML directly for simple changes

Ensure all BPMN files:
- Follow BPMN 2.0 specification
- Include SpiffWorkflow extensions where needed
- Have proper sequence flows
- Include error handling where appropriate
