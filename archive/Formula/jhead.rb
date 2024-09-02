class Jhead < Formula
  desc "Extract Digicam setting info from EXIF JPEG headers"
  homepage "https://github.com/Matthias-Wandel/jhead"
  url "https://github.com/Matthias-Wandel/jhead/archive/3.06.0.1.tar.gz"
  sha256 "5c5258c3d7a840bf831e22174e4a24cb1de3baf442f7cb73d5ab31b4ae0b0058"
  license :public_domain

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/jhead"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5122381048e0751f46c6fce01224d4c9e5e0989427ca85233f90205bbbb9263a"
  end

  # Patch to provide a proper install target to the Makefile. A variation
  # of this patch has been submitted upstream at
  # https://github.com/Matthias-Wandel/jhead/pull/45. We need to
  # carry this patch until upstream decides to incorporate it.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e3288f753931921027d0def5e8d2c3dbf7073b10/jhead/3.06.0.1.patch"
    sha256 "520929fe37097fde24f36d7e0fd59ded889d1a3cbea684133398492b14628179"
  end

  def install
    ENV.deparallelize
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp test_fixtures("test.jpg"), testpath
    system "#{bin}/jhead", "-autorot", "test.jpg"
  end
end
