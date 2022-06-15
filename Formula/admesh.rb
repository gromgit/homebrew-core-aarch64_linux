class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.4/admesh-0.98.4.tar.gz"
  sha256 "1c441591f2223034fed2fe536cf73e996062cac840423c3abe5342f898a819bb"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/admesh"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "bff9da199b797de35f0e31b8a2ec59ecfe14de11d85f5ffb13dbed6f00654739"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<~EOS
      SOLID Untitled1
      FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
      OUTER LOOP
      VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
      VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
      VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
      ENDLOOP
      ENDFACET
      ENDSOLID Untitled1
    EOS
    system "#{bin}/admesh", "test.stl"
  end
end
