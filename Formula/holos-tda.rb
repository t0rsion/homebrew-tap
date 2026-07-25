class HolosTda < Formula
  desc "Vietoris-Rips persistent homology with an implicit ripser-class engine"
  homepage "https://github.com/t0rsion/holos"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.0/holos-tda-aarch64-apple-darwin.tar.xz"
      sha256 "14318e22b38d856845f92f3714e7386e082228ffa8b34c7c574bb15851db9741"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.0/holos-tda-x86_64-apple-darwin.tar.xz"
      sha256 "2a6cee3065ab4275d6b702660b4952a4faf3733381aefcc7bb3b25744bde1fb8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.0/holos-tda-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86af548480e3f0784a1a67040a97eaaad086ee71638f00d11872d9c10879253d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/t0rsion/holos/releases/download/v0.2.0/holos-tda-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "500494040e7ffa938e2df15c7fa9d31266984aeed0c2381a450bb8db4bedc2a2"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "holos" if OS.mac? && Hardware::CPU.arm?
    bin.install "holos" if OS.mac? && Hardware::CPU.intel?
    bin.install "holos" if OS.linux? && Hardware::CPU.arm?
    bin.install "holos" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
