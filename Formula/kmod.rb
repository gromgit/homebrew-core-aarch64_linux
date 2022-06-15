class Kmod < Formula
  desc "Linux kernel module handling"
  homepage "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git"
  url "https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-29.tar.xz"
  sha256 "0b80eea7aa184ac6fd20cafa2a1fdf290ffecc70869a797079e2cc5c6225a52a"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kmod"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "947621ce3b66f7306506b0e08e574c4f96cc2aa8a4823bae8a0c10135f921f71"
  end

  depends_on :linux

  def install
    system "./configure", "--with-bashcompletiondir=#{bash_completion}",
      *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    bin.install_symlink "kmod" => "depmod"
    bin.install_symlink "kmod" => "lsmod"
    bin.install_symlink "kmod" => "modinfo"
    bin.install_symlink "kmod" => "insmod"
    bin.install_symlink "kmod" => "modprobe"
    bin.install_symlink "kmod" => "rmmod"
  end

  test do
    system "#{bin}/kmod", "help"
    assert_match "Module", shell_output("#{bin}/kmod list")
  end
end
