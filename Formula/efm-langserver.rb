class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.31",
    revision: "c5c23469d4fead65fe75b450a7c3a20212bdbecc"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d08878eb835de62ac1edeb77a87c784f1ebe713a6286ed8691b8111b3777b873"
    sha256 cellar: :any_skip_relocation, big_sur:       "91dabc504c701ea899ebbb6a97be0cce966157fc5419a603e4a9ae02cf866eea"
    sha256 cellar: :any_skip_relocation, catalina:      "91dabc504c701ea899ebbb6a97be0cce966157fc5419a603e4a9ae02cf866eea"
    sha256 cellar: :any_skip_relocation, mojave:        "91dabc504c701ea899ebbb6a97be0cce966157fc5419a603e4a9ae02cf866eea"
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
