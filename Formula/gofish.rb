class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.1",
      revision: "5d14f73963cfc0c226e8b06c0f5c3404d2ec2e77"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gofish"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "69dd123aab69508f67a00f70030ed55f71a841af262cd77e510ef8339e6d2684"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
