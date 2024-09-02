class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "c24ef4a9b1c0b416c1aeb786368b36736617c60cfd1f4e871798f5abb2a18e0b"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/goawk"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "45843a57c1422d0a7d6f66d22771dd4618bcec9664e47c2151faea9968f8177d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
