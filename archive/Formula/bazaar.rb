class Bazaar < Formula
  desc "Friendly powerful distributed version control system"
  homepage "https://bazaar.canonical.com/"
  url "https://launchpad.net/bzr/2.7/2.7.0/+download/bzr-2.7.0.tar.gz"
  sha256 "0d451227b705a0dd21d8408353fe7e44d3a5069e6c4c26e5f146f1314b8fdab3"
  revision 1

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  deprecate! date: "2021-08-19", because: "is not supported. Check out `breezy` instead"

  depends_on :macos # Due to Python 2

  conflicts_with "breezy", because: "both install `bzr` binaries"

  # CVE-2017-14176
  # https://bugs.launchpad.net/brz/+bug/1710979
  patch do
    url "https://deb.debian.org/debian/pool/main/b/bzr/bzr_2.7.0+bzr6622-15.debian.tar.xz"
    sha256 "d2198b93059cc9d37c551f7bfda19a199c18f4c9c6104a8c40ccd6d0c65e6fd3"
    apply "patches/27_fix_sec_ssh"
  end

  def install
    ENV.deparallelize # Builds aren't parallel-safe

    # Make and install man page first
    system "make", "man1/bzr.1"
    man1.install "man1/bzr.1"

    # Put system Python first in path
    ENV.prepend_path "PATH", "/System/Library/Frameworks/Python.framework/Versions/Current/bin"

    system "make"
    inreplace "bzr", "#! /usr/bin/env python", "#!/usr/bin/python"
    libexec.install "bzr", "bzrlib"

    (bin/"bzr").write_env_script(libexec/"bzr", BZR_PLUGIN_PATH: "+user:#{HOMEBREW_PREFIX}/share/bazaar/plugins")
  end

  test do
    bzr = "#{bin}/bzr"
    whoami = "Homebrew"
    system bzr, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/bzr whoami")
    system bzr, "init-repo", "sample"
    system bzr, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system bzr, "add", "test.txt"
      system bzr, "commit", "-m", "test"
    end
  end
end
