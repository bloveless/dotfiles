final: prev:

rec {
  aws-sam-cli = prev.python3.pkgs.buildPythonApplication rec {
    pname = "aws-sam-cli";
    version = "1.86.1";

    src = prev.fetchPypi {
      inherit pname version;
      hash = "sha256-jPoG87DOA3k9KjCVarsMtRUbdyznUp3iXIiKUPunt9g=";
    };

    propagatedBuildInputs = with prev.python3.pkgs; [
      aws-lambda-builders
      aws-sam-translator
      dateparser
      rich
      pyyaml
      pyopenssl
      flask
      ruamel-yaml
      tomlkit
      cookiecutter
      chevron
      docker
      cfn-lint
      jmespath
      tzlocal
      requests
      serverlessrepo
      watchdog
      # aws-lambda-builders
      # aws-sam-translator
      # chevron
      # click
      # cookiecutter
      # cfn-lint
      # dateparser
      # python-dateutil
      # docker
      # flask
      # jmespath
      # requests
      # serverlessrepo
      # # tomlkit
      # watchdog
      # typing-extensions
      # regex
      # ruamel-yaml
      # pyopenssl
      # pyyaml
    ];

    postFixup = ''
      # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
      wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
    '';

    patches = [
      # Click 8.1 removed `get_terminal_size`, recommending
      # `shutil.get_terminal_size` instead.
      # (https://github.com/pallets/click/pull/2130)
      # ./support-click-8-1.patch
      # Werkzeug >= 2.1.0 breaks the `sam local start-lambda` command because
      # aws-sam-cli uses a "WERKZEUG_RUN_MAIN" hack to suppress flask output.
      # (https://github.com/cs01/gdbgui/issues/425)
      # ./use_forward_compatible_log_silencing.patch
    ];

    # fix over-restrictive version bounds
    postPatch = ''
      echo -------------------------------------- BEFORE ----------------------------------------------
      cat requirements/base.txt
      echo --------------------------------------------------------------------------------------------
      substituteInPlace requirements/base.txt \
        --replace "aws_lambda_builders==" "aws-lambda-builders #" \
        --replace "aws-sam-translator==1.68.0" "aws-sam-translator #" \
        --replace "cfn-lint~=" "cfn-lint #" \
        --replace "PyYAML>=5.4.1,==5.*" "PyYAML" \
        --replace "rich~=" "rich #" \
        --replace "click~=7.1" "click~=8.1" \
        --replace "cookiecutter~=1.7.2" "cookiecutter>=1.7.2" \
        --replace "dateparser~=1.0" "dateparser>=0.7" \
        --replace "docker~=4.2.0" "docker>=4.2.0" \
        --replace "Flask~=1.1.4" "Flask~=2.0" \
        --replace "jmespath~=0.10.0" "jmespath" \
        --replace "MarkupSafe==2.0.1" "MarkupSafe #" \
        --replace "PyYAML~=5.3" "PyYAML #" \
        --replace "regex==" "regex #" \
        --replace "requests==" "requests #" \
        --replace "typing_extensions~=4.4.0" "typing_extensions #" \
        --replace "tzlocal==3.0" "tzlocal #" \
        --replace "tomlkit==" "tomlkit #" \
        --replace "watchdog==" "watchdog #"
      echo -------------------------------------- AFTER -----------------------------------------------
      cat requirements/base.txt
      echo --------------------------------------------------------------------------------------------
    '';

    # Tests are not included in the PyPI package
    doCheck = false;

    meta = with prev.lib; {
      homepage = "https://github.com/awslabs/aws-sam-cli";
      description = "CLI tool for local development and testing of Serverless applications";
      license = licenses.asl20;
      maintainers = with maintainers; [ lo1tuma ];
    };
  };
}
