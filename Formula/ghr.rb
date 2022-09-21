class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.14.0.tar.gz"
  sha256 "e48f6080f81960ec12dad0d104cb0afe876134bab862a229c9aed91f9f618c1e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ghr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "db6adccff973b485d0d184108c599222ca3837abf03c4ccce7a12692190dc040"
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
