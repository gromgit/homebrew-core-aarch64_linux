class Qhull < Formula
  desc "Computes convex hulls in n dimensions"
  homepage "http://www.qhull.org/"
  url "http://www.qhull.org/download/qhull-2019-src-7.3.2.tgz"
  version "2019.1"
  sha256 "2b7990558c363076261564f61b74db4d0d73b71869755108a469038c07dc43fb"

  bottle do
    cellar :any
    sha256 "7205c2c6fc4694ffc46099af316070ec383b99f2af1cde1ca9d9e0f23b7b5428" => :catalina
    sha256 "33b41bad4871bd781b91ca4c418a1b5c94dc29f676288bd8f41b5ae8c302b329" => :mojave
    sha256 "91d7e43f955fb4d9513d588e4f56a6b6c6101e9a9e0f6ed73c63a045bd4b8c25" => :high_sierra
    sha256 "2b0192507bef8e077cae894ee59a2a25b490170cc1be64413caa1ac6e48da86d" => :sierra
    sha256 "98d3967e46833ff3278b6815b638b5c4b049bb621543b9015124fef83276ab01" => :el_capitan
    sha256 "00fb087ce5f3d674d22959ea820b4e3605b02ea31694d4f00d2044bc54ca3c02" => :yosemite
  end

  depends_on "cmake" => :build

  # fixes build on case-insensitive filesystems
  # see https://github.com/qhull/qhull/issues/48
  patch do
    url "https://github.com/qhull/qhull/commit/6052739c827bff64de3f05343e45fd080909759c.patch?full_index=1"
    sha256 "ed97d5920ad9c09e028a26da1f0e8d9d313f3e757d52c14ea562827d6c865804"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    input = Utils.popen_read(bin/"rbox", "c", "D2")
    output = pipe_output("#{bin}/qconvex s n 2>&1", input, 0)
    assert_match "Number of facets: 4", output
  end
end
