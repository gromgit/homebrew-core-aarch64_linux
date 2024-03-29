class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.15.0.tar.gz"
  sha256 "89180208e62bc56e1bc401ca5171291c75c2589d47732c34d8647b3e5e0522e5"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ghr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "de90b0158581b663bf8ddad17ff8ccfd8e16dfba4a36feaef06e2c444448f9e9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
