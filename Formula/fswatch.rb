class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.9.1/fswatch-1.9.1.tar.gz"
  sha256 "56d7e2ae092985839f9f26b56cfbb5b08f9741d008a5aca75ddc7563e3b75fc8"

  bottle do
    cellar :any
    sha256 "52c3462f9ca98d86caa6be80900ffde9165dd8751e5af9fdce95e401df2a5fca" => :el_capitan
    sha256 "b1d0e93fbf382d03bbffcf4db57991edf038fa0502e5b8978ee77a72da3f787d" => :yosemite
    sha256 "c28909cbc10ad00e355d910a0198de310b982f57030114185bce1f100577d557" => :mavericks
  end

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end
end
