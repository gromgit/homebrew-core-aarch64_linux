class EfmLangserver < Formula
  desc "General purpose Language Server"
  homepage "https://github.com/mattn/efm-langserver"
  url "https://github.com/mattn/efm-langserver/archive/v0.0.43.tar.gz"
  sha256 "2e0773a5a61f4995235a036082068955725435b80e522e2df21f2a1540286b64"
  license "MIT"
  head "https://github.com/mattn/efm-langserver.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86873a66bd1e75de03b4b6e8e43995e6bedc1fb768bfe275fdbd283b4be6044f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86873a66bd1e75de03b4b6e8e43995e6bedc1fb768bfe275fdbd283b4be6044f"
    sha256 cellar: :any_skip_relocation, monterey:       "17a09484dc598abebb1ef8f7b3e673a1d53d274df9658be61f34f230942847b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "17a09484dc598abebb1ef8f7b3e673a1d53d274df9658be61f34f230942847b3"
    sha256 cellar: :any_skip_relocation, catalina:       "17a09484dc598abebb1ef8f7b3e673a1d53d274df9658be61f34f230942847b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44091ffe0e4503c5fb8d5f47e32333a64207074afddd9a3e0177bb1cb2c85644"
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
