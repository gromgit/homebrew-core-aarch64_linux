class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.26",
    revision: "26be4445542b8aa1aa0233a856ade7161644035c"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "df90e5180b1d93ffbe8435bf849cc80cd0890e7df34b5ce17ecf1af15f013f45" => :big_sur
    sha256 "77d85f1f8510268844579470f58f48dd0a4f12657196133fa526574bdbd7788e" => :catalina
    sha256 "1bff252177ab0969be92b57fb25c5a80711bccdf533a235d68522f68c7191eb4" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"config.yml").write <<~EOS
      version: 2
      root-markers:
        - ".git/"
      languages:
        python:
          - lint-command: "flake8 --stdin-display-name ${INPUT} -"
            lint-stdin: true
    EOS
    output = shell_output("#{bin}/efm-langserver -c #{testpath/"config.yml"} -d")
    assert_match "version: 2", output
    assert_match "lint-command: flake8 --stdin-display-name ${INPUT} -", output
  end
end
