class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with imath.rb when updating.
  url "https://github.com/openexr/openexr/archive/v3.0.1.tar.gz"
  sha256 "6d14a8df938bbbd55dd6e55b24c527fe9323fe6a45f704e56967dfbf477cecc1"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e0fce86c7d6b0a32c517e5636d13b272a83f34df60b8c1f8a914694c40f0cdbc"
    sha256 cellar: :any, big_sur:       "b2b31643cf746ad460034df8d020b3a97d070edcd418716259e1bd501f9a8e5f"
    sha256 cellar: :any, catalina:      "136eb8c771d87ab27dbded4b1381def640342be80a9c5d7a7a16fa43970890bb"
    sha256 cellar: :any, mojave:        "c87a3697f6d0bc82d901cb11a5563d4e5cfb712f8b9d612f2cd949a06be61a32"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "imath"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
