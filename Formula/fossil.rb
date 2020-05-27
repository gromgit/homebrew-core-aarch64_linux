class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.11.tar.gz"
  sha256 "3d5a04bbe0075edd7f04c64ffc8f3af71d16565bf606b753f5d5752e48ff3631"
  head "https://www.fossil-scm.org/", :using => :fossil

  bottle do
    cellar :any
    sha256 "7150f265bb051a7fa08ec937cfbbca186f9a17d3a2cee97fcbf9cdc1d7640a0d" => :catalina
    sha256 "747af87e2e1be5c9b5ffe39f7623a38c6c02fa79d2e0c57f1388a7bf226d4a8d" => :mojave
    sha256 "b1fa6b1c31527b905a46dead91e1692a1c04240776a9a91b263c020c96e97ae0" => :high_sierra
  end

  depends_on "openssl@1.1"
  uses_from_macos "zlib"

  def install
    args = [
      # fix a build issue, recommended by upstream on the mailing-list:
      # https://permalink.gmane.org/gmane.comp.version-control.fossil-scm.user/22444
      "--with-tcl-private-stubs=1",
      "--json",
      "--disable-fusefs",
    ]

    args << if MacOS.sdk_path_if_needed
      "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
    else
      "--with-tcl-stubs"
    end

    system "./configure", *args
    system "make"
    bin.install "fossil"
  end

  test do
    system "#{bin}/fossil", "init", "test"
  end
end
