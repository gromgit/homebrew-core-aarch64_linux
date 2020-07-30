class Modules < Formula
  desc "Dynamic modification of a user's environment via modulefiles"
  homepage "https://modules.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/modules/Modules/modules-4.5.2/modules-4.5.2.tar.bz2"
  sha256 "9366a2c6230f7ce4b5861a0629db10867f39144e382d209681619fe273950655"

  bottle do
    cellar :any
    sha256 "0eff45eac8ca106c0682606a4e20e134dbdf0c76ff9273984a88fc48744a8190" => :catalina
    sha256 "45dcef5e8a7e67b96b25cae336343eee677a699afff66ea4039742d1d6599d74" => :mojave
    sha256 "06b3c839f16bda9ebdac25ea1519533994fdb84dd89dfe6de8f56fe685508765" => :high_sierra
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --datarootdir=#{share}
      --with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework
      --without-x
    ]
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      To activate modules, add the following at the end of your .zshrc:
        source #{opt_prefix}/init/zsh
      You will also need to reload your .zshrc:
        source ~/.zshrc
    EOS
  end

  test do
    assert_match "restore", shell_output("#{bin}/envml --help")
    output = shell_output("zsh -c 'source #{prefix}/init/zsh; module' 2>&1")
    assert_match version.to_s, output
  end
end
