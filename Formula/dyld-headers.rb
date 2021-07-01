class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/dyld/dyld-852.tar.gz"
  sha256 "a97edb9c74f3ccb3084f7076c8da07248d609d79a4ba30fb39b8692a7d309a97"
  license "APSL-2.0"

  livecheck do
    url "https://opensource.apple.com/tarballs/dyld/"
    regex(/href=.*?dyld[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "030bc735c39f496f111c071ac3d0f2b5fc73e03e2d969ac30a6a8ef3362e9148"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
