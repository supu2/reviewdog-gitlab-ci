#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import json

# Example output: {"message": "<msg>", "location": {"path": "<file path>", "range": {"start": {"line": 14, "column": 15}}}, "severity": "ERROR"}
def report_array():
    test = {}
    test['location'] = {}
    test['location']['range'] = {}
    test['location']['range']['start'] = {}
    test['location']['range']['start']['line'] = 1 
    test['location']['range']['start']['column'] = 1 
    test['severity'] = "ERROR"
    return test

def main():
    baseline = json.load(sys.stdin)
    if not baseline.get('Results'):
        baseline['Results'] = {}

    results = []
    for finding in baseline['Results']:
        test = report_array()
        test['location']['path'] = finding['Target']
        if finding.get("Class") == "lang-pkgs":
            test['message'] = "|Severity|PkgName|InstalledVersion|VulnerabilityID|URL|\n|---|---|---|---|---|\n"
            vulns = finding.get("Vulnerabilities")
            if vulns:
                for vuln in vulns:
                    test['message'] = test['message'] +"|"+ vuln['Severity'] +"|"+ vuln['PkgName'] +"|"+ vuln['InstalledVersion'] +"|"+ vuln['VulnerabilityID'] +"|"+ vuln['PrimaryURL'] +"|\n"
                results.append(test)
        elif finding.get("Class") == "secret":
            secrets = finding.get('Secrets')
            if secrets:
                for secret in secrets:
                    test = report_array()
                    test['location']['path'] = finding['Target']
                    test['location']['range']['start']['line'] = secret.get("StartLine") 
                    test['location']['range']['start']['column'] = 1 
                    test['message'] = "Secret found: " + secret.get('Title')
                    results.append(test)
        else:
            sys.stderr.write('Error: %s\n' % finding.get('Class'))
    try:
        for line in results:
            sys.stdout.write(json.dumps(line))
            sys.stdout.write('\n')
    except Exception as error:
        sys.stderr.write('Error: %s\n' % error)
        return 1
    return 0


if __name__ == '__main__':
    sys.exit(main())