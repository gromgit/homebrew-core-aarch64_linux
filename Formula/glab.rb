class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://glab.readthedocs.io/"
  url "https://github.com/profclems/glab/archive/v1.22.0.tar.gz"
  sha256 "4b700d46cf9ee8fe6268e7654326053f4366aa3e072b5c3f3d243930a6e89edc"
  license "MIT"
  head "https://github.com/profclems/glab.git", branch: "trunk"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glab"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "18f33cdf3dacd683bb92239bf54e3632e5760faea4c9e012e44af87b2bd78012"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/profclems/test.git"
    cd "test" do
      assert_match "Clement Sam", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
