class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "https://pg_top.gitlab.io"
  url "https://ftp.postgresql.org/pub/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 3

  # 4.0.0 is out, but unfortunatley no longer supports OS/X.  Therefore
  # we only look for the latest 3.x release until upstream adds OS/X support back.
  livecheck do
    url "https://gitlab.com/pg_top/pg_top.git"
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "a8bd95ff06d4f746e3763933fee8f4118b5ae6e3d16c4a8e2ff1bc675bd4091a" => :catalina
    sha256 "d31b2fb44c6d363f0f635bf6a16427968ca610ea285569bfa867bea6d0437549" => :mojave
    sha256 "32637c635d8da78d4910df2dabd474f4115c31cba57890ad053b3a43cb38a758" => :high_sierra
    sha256 "5f06ae8b8ef1c979143e19c0527c31c8d649d23e1e9612c63bc6c5ff05bf8276" => :sierra
    sha256 "6d0104d461d7187ad02e1085098f2dad4fa00c4f2db93b1b910a6a072517ca54" => :el_capitan
  end

  depends_on "postgresql"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-postgresql=#{Formula["postgresql"].opt_prefix}"
    (buildpath/"config.h").append_lines "#define HAVE_DECL_STRLCPY 1"
    # On modern OS/X [v]snprinf() are macros that optionally add some security checks
    # In c.h this package provides their own declaration of these assuming they're
    # normal functions.  This collides with macro expansion badly but since we don't
    # need the declarations anyway just change the string to something harmless:
    inreplace "c.h", "snprintf", "unneeded_declaration_of_snprintf"
    # This file uses "vm_stats" as a symbol name which conflicts with vm_stats()
    # function in the SDK:
    inreplace "machine/m_macosx.c", "vm_stats", "vm_stats_data"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
