class Rats < Formula
  desc "Rough auditing tool for security"
  homepage "https://security.web.cern.ch/security/recommendations/en/codetools/rats.shtml"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/rough-auditing-tool-for-security/rats-2.4.tgz"
  sha256 "2163ad111070542d941c23b98d3da231f13cf065f50f2e4ca40673996570776a"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rats"
    sha256 aarch64_linux: "9998a1aafaed88b26b1a1d2e8014004b985107336a81398498a5c50984060351"
  end

  uses_from_macos "expat"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
  end

  test do
    system "#{bin}/rats"
  end
end
