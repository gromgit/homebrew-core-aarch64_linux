class Libvidstab < Formula
  desc "Transcode video stabilization plugin"
  homepage "http://public.hronopik.de/vid.stab/"
  url "https://github.com/georgmartius/vid.stab/archive/v1.1.0.tar.gz"
  sha256 "14d2a053e56edad4f397be0cb3ef8eb1ec3150404ce99a426c4eb641861dc0bb"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/libvidstab"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "ee4c27055e9beb71ccdf0534dce69201ca51e5ed8b2ef4c41cc216d0bd7ee80d"
  end

  depends_on "cmake" => :build

  # A bug in the FindSSE CMake script means that, if a variable is defined
  # as an empty string without quoting, it doesn't get passed to a function
  # and CMake throws an error. This only occurs on ARM, because the
  # sysctl value being checked is always a non-empty string on Intel.
  # Upstream PR: https://github.com/georgmartius/vid.stab/pull/93
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/5bf1a0e0cfe666ee410305cece9c9c755641bfdf/libvidstab/fix_cmake_quoting.patch"
    sha256 "45c16a2b64ba67f7ca5335c2f602d8d5186c29b38188b3cc7aff5df60aecaf60"
  end

  def install
    system "cmake", ".", "-DUSE_OMP=OFF", *std_cmake_args
    system "make", "install"
  end
end
