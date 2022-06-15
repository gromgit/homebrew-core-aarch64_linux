class Smu < Formula
  desc "Simple markup with markdown-like syntax"
  homepage "https://github.com/Gottox/smu"
  url "https://github.com/Gottox/smu/archive/v1.5.tar.gz"
  sha256 "f3bb18f958962679a7fb48d7f8dcab8b59154d66f23c9aba02e78103106093a4"
  license "MIT"
  head "https://github.com/Gottox/smu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/smu"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "8da32c5c8fa7aafd4ef95a036b4f2f9f3ae3d580856c1e3ead398524d7a9f3a4"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.md").write "[Homebrew](https://brew.sh)"
    assert_equal "<p><a href=\"https://brew.sh\">Homebrew</a></p>\n", shell_output("#{bin}/smu test.md")
  end
end
