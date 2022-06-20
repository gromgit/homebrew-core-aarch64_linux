class Snap7 < Formula
  desc "Ethernet communication suite that works natively with Siemens S7 PLCs"
  homepage "https://snap7.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/snap7/1.4.2/snap7-full-1.4.2.7z"
  sha256 "1f4270cde8684957770a10a1d311c226e670d9589c69841a9012e818f7b9f80e"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/snap7"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "66b6416e89378b5e973ce36708658bafc5cd525513d03ffbb69cd2ef5a0a0a47"
  end

  def install
    lib.mkpath
    os_dir = OS.mac? ? "osx" : "unix"
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    system "make", "-C", "build/#{os_dir}",
                   "-f", "x86_64_#{os}.mk",
                   "install", "LibInstall=#{lib}"
    include.install "release/Wrappers/c-cpp/snap7.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "snap7.h"
      int main()
      {
        S7Object Client = Cli_Create();
        Cli_Destroy(&Client);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-L#{lib}", "-lsnap7"
    system "./test"
  end
end
