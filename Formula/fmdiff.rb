class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://github.com/brunodefraine/fmscripts"
  url "https://github.com/brunodefraine/fmscripts/archive/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  license :public_domain
  head "https://github.com/brunodefraine/fmscripts.git", branch: "master"

  bottle do
    sha256 aarch64_linux: "45492fb95de6a5adad25722737543da5f5b1b1b0a26c1816138fb9b43673ab37" # fake aarch64_linux
  end

  # Needs FileMerge.app, which is part of Xcode.
  depends_on :macos
  depends_on :xcode

  def install
    system "make"
    system "make", "DESTDIR=#{bin}", "install"
  end

  test do
    ENV.prepend_path "PATH", testpath

    # dummy filemerge script
    (testpath/"filemerge").write <<~EOS
      #!/bin/sh
      echo "it works"
    EOS

    chmod 0744, testpath/"filemerge"
    touch "test"

    assert_match(/it works/, shell_output("#{bin}/fmdiff test test"))
  end
end
