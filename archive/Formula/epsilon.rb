class Epsilon < Formula
  desc "Powerful wavelet image compressor"
  homepage "https://epsilon-project.sourceforge.io"
  url "https://downloads.sourceforge.net/project/epsilon-project/epsilon/0.9.2/epsilon-0.9.2.tar.gz"
  sha256 "5421a15969d4d7af0ac0a11d519ba8d1d2147dc28d8c062bf0c52f3a0d4c54c4"
  license all_of: [
    "BSD-3-Clause",
    any_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(%r{url=.*?/epsilon[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/epsilon"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2368e4faddcb053aeb892914f0c76ec6400bc91c2d6724cae65969ec3801990b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "popt"

  def install
    # None of our patches apply, so regenerate `configure` to fix the `-flat_namespace` bug.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/epsilon", "--version"
  end
end
