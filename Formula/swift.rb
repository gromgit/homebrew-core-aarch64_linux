class Swift < Formula
  desc "High-performance system programming language"
  homepage "https://github.com/apple/swift"
  url "https://github.com/apple/swift/archive/swift-5.2.2-RELEASE.tar.gz"
  sha256 "92b0d1225e61a521ea10fe25f2cc35a2ad50ac55d1690d710f675d4db0c13b35"

  bottle do
    sha256 "59f15b07a9f1c3cf4d120d41a264b0ccbeadf720fe9ad6a758c7faa09d6eccfd" => :catalina
    sha256 "97b6b476fc7a0a538719ecd84c50d310dfb66a5d4c6fa67d79cfaddaf4504d6c" => :mojave
  end

  keg_only :provided_by_macos

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  # Has strict requirements on the minimum version of Xcode
  # https://github.com/apple/swift#system-requirements
  depends_on :xcode => ["11.2", :build]

  uses_from_macos "icu4c"

  # This formula is expected to have broken/missing linkage to
  # both UIKit.framework and AssetsLibrary.framework. This is
  # simply due to the nature of Swift's SDK Overlays.
  resource "llvm-project" do
    url "https://github.com/apple/llvm-project/archive/swift-5.2.2-RELEASE.tar.gz"
    sha256 "2c30e793e4bc29dc396fab522bebda731bb25be0019b07f314e70139c94de552"
  end

  resource "cmark" do
    url "https://github.com/apple/swift-cmark/archive/swift-5.2.2-RELEASE.tar.gz"
    sha256 "0992aa8065beb88c8471e30e414a243be3e270b02b66e4c242ba741169baafe4"
  end

  resource "llbuild" do
    url "https://github.com/apple/swift-llbuild/archive/swift-5.2.2-RELEASE.tar.gz"
    sha256 "b54ec43c58bf2fddfcc4e83fe744567f05274feb024dd2a39dba6b1badb49fac"
  end

  resource "swiftpm" do
    url "https://github.com/apple/swift-package-manager/archive/swift-5.2.2-RELEASE.tar.gz"
    sha256 "6d259436b1c09512e285187eb8794bbf550bdb513e243bc46e4790df0b1b9be8"
  end

  resource "indexstore-db" do
    url "https://github.com/apple/indexstore-db/archive/swift-5.2.2-RELEASE.tar.gz"
    sha256 "e7fe557a21a357025ef27a4036582a3b2393d37ba1182e2ce535f10fded2f6a1"
  end

  resource "sourcekit-lsp" do
    url "https://github.com/apple/sourcekit-lsp/archive/swift-5.2.2-RELEASE.tar.gz"
    sha256 "a712da9e3e2ff5d3d584ab2030e786c095bd25ecf33a00eda6bea5f261685c09"
  end

  def install
    workspace = buildpath.parent
    build = workspace/"build"

    toolchain_prefix = "/Swift-#{version}.xctoolchain"
    install_prefix = "#{toolchain_prefix}/usr"

    ln_sf buildpath, workspace/"swift"
    resources.each { |r| r.stage(workspace/r.name) }

    mkdir build do
      # List of components to build
      swift_components = %w[
        compiler clang-resource-dir-symlink stdlib sdk-overlay
        tools editor-integration toolchain-tools license
        sourcekit-xpc-service swift-remote-mirror
        swift-remote-mirror-headers parser-lib
      ]
      llvm_components = %w[
        llvm-cov llvm-profdata IndexStore clang
        clang-resource-headers compiler-rt clangd
      ]

      args = %W[
        --release --assertions
        --no-swift-stdlib-assertions
        --build-subdir=#{build}
        --llbuild --swiftpm
        --indexstore-db --sourcekit-lsp
        --jobs=#{ENV.make_jobs}
        --verbose-build
        --
        --workspace=#{workspace}
        --install-destdir=#{prefix}
        --toolchain-prefix=#{toolchain_prefix}
        --install-prefix=#{install_prefix}
        --host-target=macosx-x86_64
        --stdlib-deployment-targets=macosx-x86_64
        --build-swift-dynamic-stdlib
        --build-swift-dynamic-sdk-overlay
        --build-swift-stdlib-unittest-extra
        --install-swift
        --swift-install-components=#{swift_components.join(";")}
        --llvm-install-components=#{llvm_components.join(";")}
        --install-llbuild
        --install-swiftpm
        --install-sourcekit-lsp
      ]

      system "#{workspace}/swift/utils/build-script", *args
    end
  end

  test do
    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }

      print("(\(base)^\(exponent_inner))^\(exponent_outer) == \(answer)")
    EOS
    output = shell_output("#{prefix}/Swift-#{version}.xctoolchain/usr/bin/swift -v test.swift")
    assert_match "(2^3)^4 == 4096\n", output
  end
end
