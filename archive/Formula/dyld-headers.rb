class DyldHeaders < Formula
  desc "Header files for the dynamic linker"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/dyld/archive/refs/tags/dyld-960.tar.gz"
  sha256 "4d5a878221ba7e099e1d8f0ff20e816fdad9fda3587e5c5c74e2a52fcc5c41d0"
  license "APSL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/dyld-headers"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c6a13a03992f22866cc09bbfa20878de02343b1ddd12d724374ae13fd7c935fa"
  end

  keg_only :provided_by_macos

  def install
    include.install Dir["include/*"]
  end
end
