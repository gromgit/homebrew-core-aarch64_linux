class John < Formula
  desc "Featureful UNIX password cracker"
  homepage "https://www.openwall.com/john/"
  url "https://www.openwall.com/john/k/john-1.9.0.tar.xz"
  sha256 "0b266adcfef8c11eed690187e71494baea539efbd632fe221181063ba09508df"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?john[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/john"
    sha256 aarch64_linux: "d419619b19cf64ecf0ab866c85cc7ebdf001dcf2c295c766fd827843f3349953"
  end

  conflicts_with "john-jumbo", because: "both install the same binaries"

  # Backport of official patch from jumbo fork (https://www.openwall.com/lists/john-users/2016/01/04/1)
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/cd039571f9a3e9ecabbe68bdfb443e3abaae6270/john/1.9.0.patch"
    sha256 "3137169c7f3c25bf58a4f4db46ddf250e49737fc2816a72264dfe87a7f89b6a1"
  end

  def install
    inreplace "src/params.h" do |s|
      s.gsub!(/#define JOHN_SYSTEMWIDE[[:space:]]*0/, "#define JOHN_SYSTEMWIDE 1")
      s.gsub!(/#define JOHN_SYSTEMWIDE_EXEC.*/, "#define JOHN_SYSTEMWIDE_EXEC \"#{pkgshare}\"")
      s.gsub!(/#define JOHN_SYSTEMWIDE_HOME.*/, "#define JOHN_SYSTEMWIDE_HOME \"#{pkgshare}\"")
    end

    ENV.deparallelize

    target = if OS.mac?
      "macosx-x86-64"
    else
      "linux-x86-64"
    end

    system "make", "-C", "src", "clean", "CC=#{ENV.cc}", target

    prefix.install "doc/README"
    doc.install Dir["doc/*"]
    %w[john unafs unique unshadow].each do |b|
      bin.install "run/#{b}"
    end
    pkgshare.install Dir["run/*"]
  end

  test do
    (testpath/"passwd").write <<~EOS
      root:$1$brew$dOoH2.7QsPufgT8T.pihw/:0:0:System Administrator:/var/root:/bin/sh
    EOS
    system "john", "--wordlist=#{pkgshare}/password.lst", "passwd"
    assert_match(/snoopy/, shell_output("john --show passwd"))
  end
end
