class Aptly < Formula
  desc "Swiss army knife for Debian repository management"
  homepage "https://www.aptly.info/"
  url "https://github.com/aptly-dev/aptly/archive/v1.5.0.tar.gz"
  sha256 "07e18ce606feb8c86a1f79f7f5dd724079ac27196faa61a2cefa5b599bbb5bb1"
  license "MIT"
  head "https://github.com/aptly-dev/aptly.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/aptly"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "615b207f6eaf8431fb876bb0b7284f8686f9cd67efd08e0ebbcc9f9e35ce8b95"
  end

  depends_on "go" => :build

  def install
    system "go", "generate" if build.head?
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    bash_completion.install "completion.d/aptly"
    zsh_completion.install "completion.d/_aptly"

    man1.install "man/aptly.1"
  end

  test do
    assert_match "aptly version:", shell_output("#{bin}/aptly version")
    (testpath/".aptly.conf").write("{}")
    result = shell_output("#{bin}/aptly -config='#{testpath}/.aptly.conf' mirror list")
    assert_match "No mirrors found, create one with", result
  end
end
