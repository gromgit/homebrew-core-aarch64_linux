class Cntlm < Formula
  desc "NTLM authentication proxy with tunneling"
  homepage "https://cntlm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cntlm/cntlm/cntlm%200.92.3/cntlm-0.92.3.tar.bz2"
  sha256 "7b603d6200ab0b26034e9e200fab949cc0a8e5fdd4df2c80b8fc5b1c37e7b930"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/cntlm[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cntlm"
    sha256 aarch64_linux: "80923af8198cfe2e8673c082f7492e4c018ad3aebef513a0da77cfbdec7aa021"
  end

  def install
    system "./configure"
    system "make", "CC=#{ENV.cc}", "SYSCONFDIR=#{etc}"
    # install target fails - @adamv
    bin.install "cntlm"
    man1.install "doc/cntlm.1"
    etc.install "doc/cntlm.conf"
  end

  def caveats
    "Edit #{etc}/cntlm.conf to configure Cntlm"
  end

  plist_options startup: true

  service do
    run [opt_bin/"cntlm", "-f"]
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/cntlm -h 2>&1", 1)

    bind_port = free_port
    (testpath/"cntlm.conf").write <<~EOS
      # Cntlm Authentication Proxy Configuration
      Username	testuser
      Domain		corp-uk
      Password	password
      Proxy		localhost:#{free_port}
      NoProxy		localhost, 127.0.0.*, 10.*, 192.168.*
      Listen		#{bind_port}
    EOS

    fork do
      exec "#{bin}/cntlm -c #{testpath}/cntlm.conf -v"
    end
    sleep 2
    assert_match "502 Parent proxy unreacheable", shell_output("curl -s localhost:#{bind_port}")
  end
end
