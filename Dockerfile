FROM python:alpine
RUN apk add --no-cache jq git
ENV BIN_PATH="/usr/local/bin" 
RUN REVIEWDOG_VERSION="0.14.1" \
    && wget -q https://github.com/reviewdog/reviewdog/releases/download/v${REVIEWDOG_VERSION}/reviewdog_${REVIEWDOG_VERSION}_Linux_x86_64.tar.gz -O - \
    | tar zxf - reviewdog  -O > $BIN_PATH/reviewdog \
    && chmod +x $BIN_PATH/reviewdog
RUN export TFSEC_VERSION="v1.28.1" \
    && wget -q https://github.com/aquasecurity/tfsec/releases/download/${TFSEC_VERSION}/tfsec-linux-amd64 -O $BIN_PATH/tfsec \
    && chmod +x  $BIN_PATH/tfsec \
    && wget https://raw.githubusercontent.com/reviewdog/action-tfsec/master/to-rdjson.jq -O /opt/tfsec-to-rdjson.jq
RUN export TFLINT_VERSION="0.45.0" \
    && wget -q https://github.com/terraform-linters/tflint/releases/download/v${TFLINT_VERSION}/tflint_linux_amd64.zip -O /tmp/tflint.zip \
    && unzip -x /tmp/tflint.zip -d $BIN_PATH \ 
    && rm -rf  /tmp/tflint.zip  \
    && chmod +x $BIN_PATH/tflint
RUN export HADOLINT_VERSION="v2.12.0" \
    && wget -q https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-Linux-x86_64 -O $BIN_PATH/hadolint \ 
    && chmod +x  $BIN_PATH/hadolint \
    && wget https://github.com/reviewdog/action-hadolint/raw/master/to-rdjson.jq -O /opt/hadolint-to-rdjson.jq
RUN export SHELLCHECK_VERSION="0.9.0" \
    && wget -qO- "https://github.com/koalaman/shellcheck/releases/download/v${SHELLCHECK_VERSION}/shellcheck-v${SHELLCHECK_VERSION}.linux.x86_64.tar.xz" \
    | tar -xJf - shellcheck-v${SHELLCHECK_VERSION}/shellcheck -O > $BIN_PATH/shellcheck \
    && chmod +x $BIN_PATH/shellcheck
RUN export GITLEAKS_VERSION="8.15.3" \
    && wget -q https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_x64.tar.gz -O - \
    | tar zxf - gitleaks  -O > $BIN_PATH/gitleaks \
    && chmod +x $BIN_PATH/gitleaks
COPY reviewdog-trivy.py /usr/local/bin/reviewdog-trivy
RUN export TRIVY_VERSION="0.37.3" \
    && wget -q https://github.com/aquasecurity/trivy/releases/download/v${TRIVY_VERSION}/trivy_${TRIVY_VERSION}_Linux-64bit.tar.gz -O - \
    | tar zxf - trivy  -O > $BIN_PATH/trivy \
    && chmod +x $BIN_PATH/trivy \
    && chmod +x $BIN_PATH/reviewdog-trivy
RUN export ANSIBLELINT_VERSION="6.10.0" \
    && pip install --no-cache-dir ansible-lint=="${ANSIBLELINT_VERSION}" "ansible>=2.9,<2.11"
RUN export CHECKOV_VERSION="2.3.33" \
    && pip install --no-cache-dir checkov=="${CHECKOV_VERSION}"
RUN export SEMGREP_VERSION="1.12" \
    && pip install --no-cache-dir """semgrep>="${SEMGREP_VERSION}""""
RUN export FLAKE8_VERSION="6.0" \
    && pip install --no-cache-dir """flake8>="${FLAKE8_VERSION}""""
RUN export YAMLLINT_VERSION="1.29" \
    && pip install --no-cache-dir """yamllint>="${YAMLLINT_VERSION}""""
