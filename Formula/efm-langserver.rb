class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver.git",
    tag:      "v0.0.34",
    revision: "b7a20ec38aaea8fe0799d46cf317a861f46b5d55"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf1fe4444df6269c8fde32dab4cbfafd633720ef4a8e79381825da8a0e786c83"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5d33694c505e7ad140ad56a165a1707f9adb690770b9190fd37833d46650321"
    sha256 cellar: :any_skip_relocation, catalina:      "a5d33694c505e7ad140ad56a165a1707f9adb690770b9190fd37833d46650321"
    sha256 cellar: :any_skip_relocation, mojave:        "a5d33694c505e7ad140ad56a165a1707f9adb690770b9190fd37833d46650321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68b68f2d269614e57587b86605b5f94628ef921560462f4f721ea53d9184fade"
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
