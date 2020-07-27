class Fossil < Formula
  desc "Distributed software configuration management"
  homepage "https://www.fossil-scm.org/"
  url "https://www.fossil-scm.org/index.html/uv/fossil-src-2.11.1.tar.gz"
  sha256 "b391f34fada5f16eba452f36d2ad8baa3fe2a5267bf8f4169cb1b9832c0cb8eb"
  head "https://www.fossil-scm.org/", using: :fossil

  bottle do
    cellar :any
    sha256 "186fcbf32d112fa6ae7f38c4f5c8ad3808bd3ae910a596fdecfa878ce6a98e75" => :catalina
    sha256 "16056fa1186ab2aa51b6e4d5cb1c29be8c8b70819f814a4e0f41015bd3c8794b" => :mojave
    sha256 "21e95d61a0ec2e904887063073a629cba63267658b0611abf4a6f1de64ec67b0" => :high_sierra
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
