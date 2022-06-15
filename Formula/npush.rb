class Npush < Formula
  desc "Logic game similar to Sokoban and Boulder Dash"
  homepage "https://npush.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/npush/npush/0.7/npush-0.7.tgz"
  sha256 "f216d2b3279e8737784f77d4843c9e6f223fa131ce1ebddaf00ad802aba2bcd9"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/npush/code/"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/npush"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "1d8888963e889ad0d3d80ebf8f388a46f291ca8d5acdd42c54171533e0c9108c"
  end

  uses_from_macos "ncurses"

  def install
    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    inreplace "Makefile", "$(PROGRAM) $(OBJECTS)", "$(PROGRAM) $(OBJECTS) -lncurses" unless OS.mac?
    system "make"
    pkgshare.install ["npush", "levels"]
    (bin/"npush").write <<~EOS
      #!/bin/sh
      cd "#{pkgshare}" && exec ./npush $@
    EOS
  end
end
