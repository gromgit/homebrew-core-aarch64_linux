class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.4.tar.gz"
  sha256 "141f39d866f62274b2262164baaac6202f60749862c84c2e6ed231f6d03ee8df"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bcal"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "0fb0211652b5180e91e5a3854115f247391b49109c2ab2bb1dd18205958ddb4e"
  end

  on_linux do
    depends_on "readline"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
