class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/toolkit.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  version "67"
  sha256 "6f4980445fee4d363dbce6f571819f4a248358d2c1bebca47e0743eedfe9935e"

  # The `stable` tarball is unversioned, so we have to identify the latest
  # version from text on the homepage.
  livecheck do
    url :homepage
    regex(/current SPICE Toolkit version is (?:<[^>]+?>)?N0*(\d+)/im)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cspice"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ed4dfb27ec97af1396b0067855df0fc7d7037e30113e4dd9185706f6d44e3da5"
  end

  on_linux do
    depends_on "tcsh"
  end

  conflicts_with "openhmd", because: "both install `simple` binaries"
  conflicts_with "libftdi0", because: "both install `simple` binaries"
  conflicts_with "enscript", because: "both install `states` binaries"

  def install
    # Use brewed csh on Linux because it is not installed in CI.
    unless OS.mac?
      Dir["src/*/*.csh"].each do |file|
        inreplace file, "/bin/csh", Formula["tcsh"].opt_bin/"csh"
      end
    end

    rm_f Dir["lib/*"]
    rm_f Dir["exe/*"]
    system "csh", "makeall.csh"
    mv "exe", "bin"
    pkgshare.install "doc", "data"
    prefix.install "bin", "include", "lib"

    lib.install_symlink "cspice.a" => "libcspice.a"
    lib.install_symlink "csupport.a" => "libcsupport.a"
  end

  test do
    system "#{bin}/tobin", "#{pkgshare}/data/cook_01.tsp", "DELME"
  end
end
